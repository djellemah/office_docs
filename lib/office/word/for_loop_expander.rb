require 'office/word/for_loop_expanders/loop_in_paragraph'
require 'office/word/for_loop_expanders/loop_over_paragraphs'

module Word
  class ForLoopExpander
    attr_accessor :main_doc, :paragraphs, :data, :options, :placeholders
    def initialize(main_doc, paragraphs, data, options = {})
      self.main_doc = main_doc
      self.paragraphs = paragraphs
      self.data = data
      self.options = options
    end

    def expand_for_loops
      # Get placeholders in paragraphs
      self.placeholders = Word::PlaceholderFinder.get_placeholders(paragraphs)
      i = 0
      while i < placeholders.length
        start_placeholder = placeholders[i]
        if start_placeholder[:placeholder_text].include?("foreach")
          end_index = get_end_index(i)
          expand_loop(i, end_index)

          i = end_index + 1
        else
          i += 1
        end
      end

      # i = 0
      # While we have placeholders
        # Get first for start
        # Loop through placeholders to get its end
        # Expand the for loop out replacing the variable placeholders
        # expand the for loops in each set generated
        # i = index_of(end_placeholder)

    end

    def get_end_index(start_index)
      level = 0
      placeholders[(start_index+1)..-1].each_with_index do |p, j|
        if p[:placeholder_text].include?("endeach") && level == 0
          return (start_index+1)+j
        elsif p[:placeholder_text].include?("endeach") && level > 0
          level -= 1
        elsif p[:placeholder_text].include?("foreach")
          level += 1
        end
      end
      raise "For each missing an end"
    end

    def expand_loop(start_index, end_index)
      start_placeholder = placeholders[start_index]
      end_placeholder = placeholders[end_index]
      inbetween_placeholders = placeholders[(start_index+1)..(end_index-1)]
      #puts "Expanding from\n #{start_placeholder.inspect}\nto\n#{end_placeholder.inspect}\n\n"
      if start_placeholder[:paragraph_index] == end_placeholder[:paragraph_index]
        # if start and end are in the same paragraph
        looper = Word::ForLoopExpanders::LoopInParagraph.new(main_doc, data, options)
        looper.expand_loop(start_placeholder, end_placeholder, inbetween_placeholders)
      elsif false
        # else if start is in a table cell and end is in a different table cell
        # loop whole row
      elsif false
        # else if start is in a table cell but end is not in a table cell at all
        # raise error
      else
        # else its over paragraphs
        looper = Word::ForLoopExpanders::LoopOverParagraphs.new(main_doc, data, options)
        looper.expand_loop(start_placeholder, end_placeholder, inbetween_placeholders)
      end
    end

  end#endclass
end#endmodule


__END__

{
  placeholder_text: '{{ i_am_holder }}',
  paragraph_index: 0,
  begin: {run_index: 3, char_index: 15},
  end: {run_index: 5, char_index: 2}
}


To add a node somewhere

preceding_r_node = @node.add_child(@node.document.create_element("r"))
populate_r_node(preceding_r_node, text)
first_run.node.add_previous_sibling(preceding_r_node)
@runs.insert(@runs.index(first_run), Run.new(preceding_r_node, self))
