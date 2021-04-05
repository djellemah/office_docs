#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.5.2
# from Racc grammar file "".
#

require 'racc/parser.rb'


module Office
  class PlaceholderGrammar < Racc::Parser

module_eval(<<'...end placeholder_grammar.racc/module_eval...', 'placeholder_grammar.racc', 114)
  def initialize
    super
    @field_path = []
    @keywords = {}
    @functors = {}
  end

  attr_accessor :field_path
  attr_accessor :image_extent

  # really these have the same function but different syntaxes so keep them separate
  attr_accessor :keywords
  attr_accessor :functors

  def to_h
    {
      field_path: field_path,
      image_extent: image_extent,
      keywords: keywords,
      functors: functors,
    }
  end

  def yydebug; true end

  def read_tokens(tokens)
    # @yydebug = true
    en = case tokens
    when Array; tokens.each
    when Enumerable; tokens
    end

    define_singleton_method(:next_token) do
      en.next
    rescue StopIteration
      nil
    end
    # return value from this is the first token on the stack
    do_parse
    to_h
  end

  # This method is called when a parse error is found.

  # ERROR_TOKEN_ID is an internal ID of token which caused error. You can get
  # string representation of this ID by calling #token_to_str.
  # ID always seems to be 1 which returns 'error' from token_to_str

  # ERROR_VALUE is a value of error token

  # value_stack is a stack of symbol values. DO NOT MODIFY this object.

  # This method raises ParseError by default.

  # If this method returns, parsers enter “error recovering mode”.
  def on_error(error_token_id, error_value, value_stack)
    # str = token_to_str error_token_id
    super
  end
...end placeholder_grammar.racc/module_eval...
##### State transition tables begin ###

racc_action_table = [
    40,    48,    46,    47,     7,    67,    49,    68,    42,    43,
    40,    48,    46,    47,    35,     6,    49,     8,    42,    43,
    44,    45,    21,    20,     2,     9,    40,    48,    46,    47,
    44,    45,    49,    10,    42,    43,    26,    27,    29,    30,
    21,    20,    21,    56,    29,    30,    44,    45,    11,    12,
     6,     6,    23,    24,    25,    31,    32,    52,    57,    58,
    59,    60,    61,    62,    63,    64,    65,    66 ]

racc_action_check = [
    26,    26,    26,    26,     1,    60,    26,    60,    26,    26,
    27,    27,    27,    27,    26,     0,    27,     2,    27,    27,
    26,    26,     9,     9,     0,     4,    62,    62,    62,    62,
    27,    27,    62,     5,    62,    62,    20,    20,    21,    21,
    25,    25,    35,    35,    40,    40,    62,    62,     6,     7,
     8,    10,    11,    13,    15,    23,    24,    28,    44,    45,
    46,    48,    50,    51,    53,    57,    58,    59 ]

racc_action_pointer = [
    12,     4,     5,   nil,    11,    18,    32,    49,    47,    20,
    48,    50,   nil,    40,   nil,    36,   nil,   nil,   nil,   nil,
    17,    14,   nil,    38,    43,    38,    -2,     8,    55,   nil,
   nil,   nil,   nil,   nil,   nil,    40,   nil,   nil,   nil,   nil,
    20,   nil,   nil,   nil,    52,    53,    54,   nil,    42,   nil,
    41,    45,   nil,    47,   nil,   nil,   nil,    43,    43,    63,
     2,   nil,    24,   nil,   nil,   nil,   nil,   nil,   nil,   nil ]

racc_action_default = [
    -3,   -42,   -42,    -2,    -5,    -7,    -9,   -42,    -3,   -42,
   -42,   -42,    70,   -42,    -4,   -11,   -12,   -13,   -14,   -15,
   -22,   -42,    -6,   -42,   -42,   -42,   -42,   -42,   -42,   -37,
   -38,    -8,    -1,   -10,   -16,   -42,   -18,   -25,   -26,   -27,
   -28,   -29,   -30,   -31,   -42,   -42,   -42,   -35,   -42,   -41,
   -42,   -24,   -36,   -42,   -19,   -20,   -22,   -42,   -42,   -42,
   -42,   -21,   -42,   -17,   -32,   -33,   -34,   -39,   -40,   -23 ]

racc_goto_table = [
    50,    16,    14,     3,     1,    22,    55,    34,    53,    36,
   nil,    13,   nil,   nil,   nil,   nil,   nil,    16,    33,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,    54,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,    69 ]

racc_goto_check = [
    14,     7,     4,     2,     1,     3,    10,    11,    12,    13,
   nil,     2,   nil,   nil,   nil,   nil,   nil,     7,     4,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,     7,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,    14 ]

racc_goto_pointer = [
   nil,     4,     3,    -5,    -7,   nil,   nil,    -8,   nil,   nil,
   -29,   -19,   -27,   -17,   -27,   nil,   nil,   nil,   nil ]

racc_goto_default = [
   nil,   nil,   nil,     4,   nil,     5,    15,    39,    17,    18,
    19,   nil,   nil,    51,   nil,    37,    38,    41,    28 ]

racc_reduce_table = [
  0, 0, :racc_error,
  5, 27, :_reduce_none,
  1, 27, :_reduce_none,
  0, 28, :_reduce_none,
  3, 28, :_reduce_4,
  1, 28, :_reduce_5,
  3, 29, :_reduce_6,
  1, 29, :_reduce_none,
  4, 31, :_reduce_8,
  1, 31, :_reduce_9,
  3, 30, :_reduce_none,
  1, 30, :_reduce_none,
  1, 32, :_reduce_12,
  1, 32, :_reduce_13,
  1, 32, :_reduce_14,
  1, 32, :_reduce_15,
  3, 34, :_reduce_16,
  3, 37, :_reduce_17,
  1, 37, :_reduce_none,
  1, 38, :_reduce_none,
  1, 38, :_reduce_none,
  4, 35, :_reduce_21,
  1, 36, :_reduce_22,
  3, 40, :_reduce_23,
  1, 40, :_reduce_none,
  1, 39, :_reduce_none,
  1, 39, :_reduce_none,
  1, 39, :_reduce_none,
  1, 39, :_reduce_28,
  1, 39, :_reduce_none,
  1, 42, :_reduce_30,
  1, 42, :_reduce_31,
  3, 41, :_reduce_32,
  3, 41, :_reduce_33,
  3, 41, :_reduce_34,
  1, 41, :_reduce_none,
  3, 33, :_reduce_36,
  1, 44, :_reduce_none,
  1, 44, :_reduce_none,
  3, 43, :_reduce_39,
  3, 43, :_reduce_40,
  1, 43, :_reduce_none ]

racc_reduce_n = 42

racc_shift_n = 70

racc_token_table = {
  false => 0,
  :error => 1,
  :NUMBER => 2,
  :IDENTIFIER => 3,
  :LRQUOTE => 4,
  :MAGIC_QUOTED => 5,
  :STRING => 6,
  :BOOLEAN => 7,
  :RANGE => 8,
  :CHAR => 9,
  :false => 10,
  :true => 11,
  "{" => 12,
  "}" => 13,
  "|" => 14,
  "." => 15,
  "[" => 16,
  "]" => 17,
  "," => 18,
  ":" => 19,
  "(" => 20,
  ")" => 21,
  "\"" => 22,
  "'" => 23,
  "X" => 24,
  "x" => 25 }

racc_nt_base = 26

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "NUMBER",
  "IDENTIFIER",
  "LRQUOTE",
  "MAGIC_QUOTED",
  "STRING",
  "BOOLEAN",
  "RANGE",
  "CHAR",
  "false",
  "true",
  "\"{\"",
  "\"}\"",
  "\"|\"",
  "\".\"",
  "\"[\"",
  "\"]\"",
  "\",\"",
  "\":\"",
  "\"(\"",
  "\")\"",
  "\"\\\"\"",
  "\"'\"",
  "\"X\"",
  "\"x\"",
  "$start",
  "cuddled",
  "placeholder",
  "field_path",
  "directives",
  "nstep",
  "directive",
  "extent",
  "keyword",
  "functor",
  "naked",
  "composite_value",
  "array_value",
  "value",
  "values",
  "string",
  "boolean",
  "range",
  "x" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

# reduce 1 omitted

# reduce 2 omitted

# reduce 3 omitted

module_eval(<<'.,.,', 'placeholder_grammar.racc', 41)
  def _reduce_4(val, _values, result)
    self.field_path = val[0]
    result
  end
.,.,

module_eval(<<'.,.,', 'placeholder_grammar.racc', 42)
  def _reduce_5(val, _values, result)
    self.field_path = val[0]
    result
  end
.,.,

module_eval(<<'.,.,', 'placeholder_grammar.racc', 46)
  def _reduce_6(val, _values, result)
    result = [*Array(val[0]), *Array(val[2])]
    result
  end
.,.,

# reduce 7 omitted

module_eval(<<'.,.,', 'placeholder_grammar.racc', 52)
  def _reduce_8(val, _values, result)
    result = [val[0], Integer(val[2])]
    result
  end
.,.,

module_eval(<<'.,.,', 'placeholder_grammar.racc', 53)
  def _reduce_9(val, _values, result)
     result = val
    result
  end
.,.,

# reduce 10 omitted

# reduce 11 omitted

module_eval(<<'.,.,', 'placeholder_grammar.racc', 58)
  def _reduce_12(val, _values, result)
    self.image_extent = val[0]
    result
  end
.,.,

module_eval(<<'.,.,', 'placeholder_grammar.racc', 59)
  def _reduce_13(val, _values, result)
    self.keywords.merge! val[0]
    result
  end
.,.,

module_eval(<<'.,.,', 'placeholder_grammar.racc', 60)
  def _reduce_14(val, _values, result)
    self.functors.merge! val[0]
    result
  end
.,.,

module_eval(<<'.,.,', 'placeholder_grammar.racc', 61)
  def _reduce_15(val, _values, result)
    self.keywords.merge! val[0]
    result
  end
.,.,

module_eval(<<'.,.,', 'placeholder_grammar.racc', 64)
  def _reduce_16(val, _values, result)
     result = {val[0].to_sym => val[2]}
    result
  end
.,.,

module_eval(<<'.,.,', 'placeholder_grammar.racc', 67)
  def _reduce_17(val, _values, result)
    result = val[1]
    result
  end
.,.,

# reduce 18 omitted

# reduce 19 omitted

# reduce 20 omitted

module_eval(<<'.,.,', 'placeholder_grammar.racc', 73)
  def _reduce_21(val, _values, result)
     result = {val[0].to_sym => val[2]}
    result
  end
.,.,

module_eval(<<'.,.,', 'placeholder_grammar.racc', 75)
  def _reduce_22(val, _values, result)
     result = {val[0].to_sym => true}
    result
  end
.,.,

module_eval(<<'.,.,', 'placeholder_grammar.racc', 80)
  def _reduce_23(val, _values, result)
    result = [*Array(val[0]), *Array(val[2])]
    result
  end
.,.,

# reduce 24 omitted

# reduce 25 omitted

# reduce 26 omitted

# reduce 27 omitted

module_eval(<<'.,.,', 'placeholder_grammar.racc', 84)
  def _reduce_28(val, _values, result)
    result = Integer val[0]
    result
  end
.,.,

# reduce 29 omitted

module_eval(<<'.,.,', 'placeholder_grammar.racc', 88)
  def _reduce_30(val, _values, result)
    result = false
    result
  end
.,.,

module_eval(<<'.,.,', 'placeholder_grammar.racc', 88)
  def _reduce_31(val, _values, result)
    result = true
    result
  end
.,.,

module_eval(<<'.,.,', 'placeholder_grammar.racc', 91)
  def _reduce_32(val, _values, result)
    result = val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'placeholder_grammar.racc', 92)
  def _reduce_33(val, _values, result)
    result = val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'placeholder_grammar.racc', 93)
  def _reduce_34(val, _values, result)
    result = val[1]
    result
  end
.,.,

# reduce 35 omitted

module_eval(<<'.,.,', 'placeholder_grammar.racc', 97)
  def _reduce_36(val, _values, result)
     result = {width: val[0], height: val[2]}
    result
  end
.,.,

# reduce 37 omitted

# reduce 38 omitted

module_eval(<<'.,.,', 'placeholder_grammar.racc', 104)
  def _reduce_39(val, _values, result)
    result = "#{val[0]}:#{val[2]}"
    result
  end
.,.,

module_eval(<<'.,.,', 'placeholder_grammar.racc', 105)
  def _reduce_40(val, _values, result)
    result = "#{val[0]}:#{val[2]}"
    result
  end
.,.,

# reduce 41 omitted

def _reduce_none(val, _values, result)
  val[0]
end

  end   # class PlaceholderGrammar
end   # module Office
