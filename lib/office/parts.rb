require 'nokogiri' # docs at http://nokogiri.org
require 'RMagick'  # docs at http://studio.imagemagick.org/RMagick/doc
require 'office/constants'
require 'office/errors'
require 'office/logger'

module Office
  class Part
    attr_accessor :name
    attr_accessor :content_type

    def has_relationships?
      !@relationships.nil?
    end

    def set_relationships(relationships_part)
      raise "multiple relationship parts for '#{@name}'" unless @relationships.nil?
      @relationships = relationships_part
    end

    # returns RelationshipsPart
    def get_relationships
      @relationships
    end

    def get_relationship_target(type)
      @relationships.get_relationship_target(type)
    end

    @@subclasses = []

    def self.from_zip_entry(entry_name, entry_io, default_content_type = nil)
      part_name = (entry_name[0] == "/" ? "" : "/") + entry_name.downcase
      extension = part_name.split('.').last
      part_class = @@subclasses.find { |sc| sc.zip_extensions.include? extension } || UnknownPart

      begin
        part_class.parse(part_name, entry_io, default_content_type)
      rescue StandardError => e
        raise PackageError.new("failed to parse package #{part_class.name} '#{part_name}' - #{e}")
      end
    end

    def self.inherited(subclass)
      @@subclasses << subclass
    end

    def self.zip_extensions
      []
    end
  end

  class XmlPart < Part
    attr_accessor :xml # Nokogiri::XML::Document

    def initialize(part_name, xml_io, content_type)
      @name = part_name
      @xml = Nokogiri::XML::Document.parse(xml_io)
      @content_type = content_type
    end

    def self.parse(part_name, io, default_content_type)
      XmlPart.new(part_name, io, default_content_type || XML_CONTENT_TYPE)
    end

    def self.zip_extensions
      [ 'xml' ]
    end
  end

  class Relationship
    attr_accessor :id
    attr_accessor :type
    attr_accessor :target_name
    attr_accessor :target_part

    def initialize(id, type, target_name)
      @id = id
      @type = type
      @target_name = target_name
    end

    def resolve_target_part(package, owner_name)
      full_name = @target_name[0] == "/" ? @target_name : owner_name[0, owner_name.rindex("/") + 1] + @target_name
      @target_part = package.get_part(full_name)
      Logger.warn "Failed to resolve relationship target '#{@target_name}' for '#{owner_name}'" if @target_part.nil?
    end
  end

  class RelationshipsPart < XmlPart
    def initialize(part_name, xml_io, content_type)
      super(part_name, xml_io, content_type)
      parse_relationships
    end

    def parse_relationships
      root = @xml.root
      raise PackageError.new("relationship part '#{@name}' has unexpected root node '#{root.name}") unless root.name == "Relationships"

      @relationships_by_id = {}
      root.children.each do |child|
        if "Relationship" == child.name
          id = child["Id"]
          @relationships_by_id[id] = Relationship.new(id, child["Type"], child["Target"].downcase)
        else
          Logger.warn "Unrecognized element '#{child.name}' in relationships XML part"
        end
      end
    end

    def map_relationships(package)
      owner = resolve_relationships_owner(package)
      raise PackageError.new("relationship part '#{@name}' references a non-existent part") if owner.nil?

      @owner_name = owner == package ? "/" : owner.name
      @relationships_by_id.values.each { |r| r.resolve_target_part(package, @owner_name) }
      owner.set_relationships(self)
    end

    def resolve_relationships_owner(package)
      return package if @name == "/_rels/.rels"

      # names are of the form "/a/b/_rels/c.xml.rels"
      path_components = @name.split('/')
      valid_name = path_components.length > 1
      valid_name &&= path_components[path_components.length - 2] == "_rels"
      valid_name &&= path_components.last[-5, 5] == ".rels"
      raise PackageError.new("relationship part '#{@name}' name is invalid") unless valid_name

      path_components.delete_at(path_components.length - 2)
      path_components.last.chop!.chop!.chop!.chop!.chop! # Ruby is awesome!
      package.get_part(path_components.join("/"))
    end

    def get_relationship_target(type)
      @relationships_by_id.values.each { |r| return r.target_part if r.type == type }
      nil
    end

    def debug_dump
      rows = @relationships_by_id.values.collect { |r| ["#{r.id}", "#{r.target_part.name}", "#{r.type}"] }
      title = "#{@owner_name == "/" ? "Package" : @owner_name} Relationships"
      Logger.debug_dump_table(title, ["ID", "Target", "Type"], rows)
    end

    def self.parse(part_name, io, default_content_type)
      RelationshipsPart.new(part_name, io, default_content_type || RELATIONSHIP_CONTENT_TYPE)
    end

    def self.zip_extensions
      [ 'rels' ]
    end
  end

  class ImagePart < Part
    attr_accessor :image # Magick::Image::Image

    def initialize(part_name, image_list)
      @name = part_name
      @image = image_list.first
      @content_type = @image.mime_type
    end

    def self.parse(part_name, io, default_content_type)
      ImagePart.new(part_name, Magick::Image::from_blob(io.read))
    end

    def self.zip_extensions
      extensions = []
      Magick.formats do |format, attributes|
        # attributes indicate RMagick support for the format BRWA (native blob, read, write, multi-image)
        extensions << format.downcase if attributes.downcase[1, 2] = 'rw'
      end
      extensions
    end
  end

  class UnknownPart < Part
    attr_accessor :content

    def initialize(part_name, io, content_type)
      Logger.warn "Unknown Package Module: #{part_name}"
      @name = part_name
      @content = io.read
      @content_type = content_type
    end

    def self.parse(part_name, io, default_content_type)
      UnknownPart.new(part_name, io, default_content_type)
    end
  end
end
