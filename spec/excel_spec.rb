require 'hash_wrap'

require_relative '../lib/office/excel'
require_relative '../lib/office/constants'
require_relative '../lib/office/nokogiri_extensions'

require_relative 'spec_helper'
require_relative 'xml_fixtures'

# copy of the minitest test cases, because specs are easier to zero in on
describe 'ExcelWorkbooksTest' do
  WORKBOOK_PATH = File.join __dir__, '/../test/content/simple-placeholders.xlsx'

  let :simple do
    Office::ExcelWorkbook.new WORKBOOK_PATH
  end

  include XmlFixtures

  def reload_workbook workbook, filename = nil, &blk
    Dir.mktmpdir do |dir|
      filename = File.join dir, (filename || File.basename(workbook.filename))
      workbook.save filename
      yield Office::ExcelWorkbook.new(filename)
    end
  end

  it 'replaces one cell' do
    sheet = simple.sheets.first
    cell = sheet.each_cell.first
    cell.value = "This is the new pump"

    reload_workbook sheet.workbook do |book|
      saved_cell = book.sheets.first.each_cell.first
      saved_cell.value.should == cell.value
      saved_cell.node.object_id.should_not == cell.node.object_id
    end
  end

  let :field_data do
    require 'yaml'
    HashWrap.new YAML.load_file 'test/content/placeholder-data.yml'
  end

  let :placeholders do
    ["{{horizontal}}", "{{manufacturer}}", "{{yes}}", "{{shop_or_serial}}", "{{model_number}}", "{{vertical}}", "{{no}}", "{{gpm}}", "{{rated_head_foot_psi}}", "{{net_psi}}", "{{rated_rpm}}", "very {{important}} thing", "{{broken_place}}", "{{streams|tabular}}"]
  end

  it 'finds placeholders - generic' do
    book = Office::ExcelWorkbook.new File.join(__dir__, '/../test/content/simple-placeholders.xlsx')
    place_cells = book.sheets.first.each_cell.filter(&:placeholder)
    place_cells.map(&:value).should == placeholders
  end

  it '#each_placeholder' do
    book = Office::ExcelWorkbook.new File.join(__dir__, '/../test/content/simple-placeholders.xlsx')
    sheet = book.sheets.first
    sheet.each_placeholder.map(&:value).should == placeholders
  end

  it 'uses Builder to replace element tree' do
    # can also just call methods on bld, but might need to set context first
    r_node = mini_shared_string_doc.build_element 'r' do |bld|
      bld.rPr do
        bld.sz val: 10
        bld.rFont val: 'Arial'
        bld.family val: 2
        bld.charset val: 1
      end
      bld.t 'Felix', 'xml:space': 'preserve'
    end

    last_si = mini_shared_string_doc.nspath('/~sst/~si').last
    last_si.children = r_node
    r_ts = mini_shared_string_doc.nspath('~sst/~si/~r/~t')
    r_ts.last.text.should == 'Felix'
    r_ts.size.should == 5
  end

  xit 'pry context' do
    node = mini_shared_string_doc.nspath('/~sst/~si').last

    binding.pry
  end

  let :simple do
    Office::ExcelWorkbook.new File.join(__dir__, '/../test/content/simple-placeholders.xlsx')
  end

  describe Office::Cell do
    describe '#value=' do
      let :sheet do simple.sheets.first end
      let :cell do sheet['A18'] end

      it 'accepts Date' do
        cell.value = 'Hello Darlink'
        cell.node.to_xml.should == "<c r=\"A18\" s=\"4\" t=\"inlineStr\">\n  <is>\n    <t>Hello Darlink</t>\n  </is>\n</c>"
      end

      xit 'accepts boolean'
      xit 'accepts inline String'
      xit 'accepts shared String'
      xit 'accepts Integer'
      xit 'accepts Float'
    end
  end

  describe 'tabular data' do
    let :dataset do
      [
      %i[rpm discharge suction net no size pitot gpm percent voltage amp],
      [1791,110,10,100,0,'Churn',nil,0,0,"477,476,477","56,55,56"],
      [1789,106,5,101,3,2.5,7.6,1500,100,"479,475,475","90,86,91"],
      [1777,96,6,91,3,2.5,17,2250,150,"477,475,474","118,115,118"],
      [1770,92,5,87,3,8.5,23,3000,170,"452,454,424","128,135,132"],
      [1762,83,2,82,3,6.1,23,3750,80,"454,424,403","124,128,135"],
      [1751,65,1,79,3,4.5,23,4500,50,"424,403,389","121,124,128"],
      ]
    end

    let :csv_data do
      require 'csv'
      dataset.map
    end

    let :simple do
      Office::ExcelWorkbook.new File.join(__dir__, '/../test/content/simple-placeholders.xlsx')
    end

    it 'replace individual row/col cells' do
      sheet = simple.sheets.first

      # set up a binding for easier evaluation of placeholder expressions
      locals = ->{}
      bnd = locals.binding

      # copy values to binding
      field_data.each do |k,v|
        bnd.local_variable_set k.to_sym, v
      end

      # split streams data
      headers, *records = field_data.streams

      # convert each row to a objecty hash
      bnd.local_variable_set :streams, records.map {|ary| HashWrap.new headers.zip(ary).to_h }

      # evaluate placeholders on all sheets
      simple.sheets.each do |sheet|
        sheet.each_placeholder do |cell|
          # of course this is ridiculously insecure
          val = bnd.eval cell.placeholder rescue 'ERROR'
          if String === val
            cell.value = cell.value.gsub(%r|{{.*?}}|, val)
          else
            cell.value = val
          end
        end
      end

      reload_workbook sheet.workbook do |book|
        # `localc --nologo #{book.filename}`
      end
    end

    it 'insert rows with tabular data' do
      sheet = simple.sheets.first
      doc = sheet.worksheet_part.xml

      placeholder_cell = sheet['A18']
      placeholder_cell.value.should =~ /tabular/

      # make the title range into normal cells
      title_range = sheet.merge_ranges.find{|range| range.cover? placeholder_cell.location}
      title_range.should_not be_nil
      sheet.delete_merge_range title_range

      headers, *records = dataset

      # overwrite header row
      headers.each_with_index do |header_value,colix|
        insert_location = placeholder_cell.location + [colix, 0]
        sheet[insert_location].value = header_value.to_s
      end

      # insert blank rows for data, from row after headers
      insert_range = Office::Range.new(placeholder_cell.location + [0,1], placeholder_cell.location + [records.first.size,records.size])
      inserted_rows = sheet.insert_rows(insert_range)

      # TODO optimise this by creating a map from inserted_rows
      # and/or allowing Cell to work on a fragment as well as on the full sheet.
      # and/or allowing the Sheet#[] to work on a nodeset of rows.
      # which means having indexing be more flexible than an array of Row instances.
      records.each_with_index do |data_row, rowix|
        data_row.each_with_index do |val, colix|
          location = insert_range.top_left + [colix, rowix]
          sheet[location].value = Integer(val) rescue val
        end
      end

      # update sheet dimension
      sheet.dimension = sheet.calculate_dimension

      reload_workbook sheet.workbook, 'insert.xlsx' do |book|
        # `localc --nologo #{book.filename}`
      end
    end

    it 'replaces a range with tabular data' do
      sheet = simple.sheets.first
      doc = sheet.worksheet_part.xml

      # TODO put most of this in Sheet#replace_tabular
      placeholder_cell = sheet['A18']
      placeholder_cell.value.should =~ /tabular/
      range = sheet.merge_ranges.find{|range| range.cover? placeholder_cell.location}
      range.should_not be_nil

      headers, *records = dataset

      # insert header
      headers.each_with_index do |header_value,colix|
        insert_location = placeholder_cell.location + [colix, 0]
        sheet[insert_location].value = header_value.to_s
      end

      # overwrite data values after header
      record_location = placeholder_cell.location + [0,1]
      records.each_with_index do |data_row, rowix|
        # check that range matches data
        data_row.size <= range.width or raise "data too long for #{range}: (#{data_row.size})#{data_row.inspect}"
        data_row.each_with_index do |val, colix|
          location = record_location + [colix, rowix]
          # TODO insert second and subsequent rows
          # TODO why does SheetData cache rows?
          # TODO what's the difference between .value = and []= ? The latter would not require LazyCell
          # also [] and []= could apply to rows, but we're kinda using sheet.sheet_data.rows for that
          sheet[location].value = Integer(val) rescue val
        end
      end

      # make the title range into normal cells
      title_range = sheet.merge_ranges.find{|range| range.cover? placeholder_cell.location}
      title_range.should_not be_nil
      sheet.delete_merge_range title_range

      # TODO update sheet range. Need to find largest cell reference number. Oof.
      # possibly grab current range, extend by loc_track, but then still need to check for rows bumped by insertion
      # unless every row insertion / row deletion / lazy cell insertion tracks the current range.
      # Hmmm. Just do it brute-force for now.
      sheet.dimension.should == 'A5:K22'
      sheet.calculate_dimension.should == 'A5:K24'
      sheet.dimension = sheet.calculate_dimension
      sheet.dimension.should == 'A5:K24'

      reload_workbook sheet.workbook, 'overwrite.xlsx' do |book|
        # `localc --nologo #{book.filename}`
      end
    end

    it "appends rows to end if they don't exist"
    it "inserts rows if necessary"
    it "creates new empty row if it doesn't exist"
  end

  describe 'row operations' do
    describe '#insert_rows'
    describe '#delete_rows' do
      it 'deletes range' do
        sheet = simple.sheets.first

        range = Office::Range.new 'A5:I17'
        sheet.delete_rows range
        sheet.dimension = sheet.calculate_dimension
        sheet.sheet_data.rows.count.should == 5
        # TODO verify that both cells and rows are renumbered correctly

        reload_workbook sheet.workbook, 'delete.xlsx' do |book|
          # `localc --nologo #{book.filename}`
        end
      end
    end
  end
end
