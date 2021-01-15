# frozen_string_literal: true

require "minitest/autorun"
require "gnomikologikon/arg_parser"

class ArgParserTest < Minitest::Test
  def test_single_file_argument_short
    arguments = %w[-s quotes]
    options = Gnomika::ArgParser.parse(arguments)

    assert_equal true, options.single_file
    assert_equal arguments[1], options.single_file_name
  end

  def test_single_file_argument_long
    arguments = %w[--single-file filename]
    options = Gnomika::ArgParser.parse(arguments)

    assert_equal true, options.single_file
    assert_equal arguments[1], options.single_file_name
  end
end
