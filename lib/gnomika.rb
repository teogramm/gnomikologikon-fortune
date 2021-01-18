# frozen_string_literal: true

require "gnomikologikon/ui"
require "gnomikologikon/arg_parser"
require "gnomikologikon/web_processing"
require "optparse"

##
# Module containing all classes and functions of the application
module Gnomika
  def self.main
    options = ArgParser.parse(ARGV)
    available_categories = Gnomika.fetch_category_info
    selected_category = select_category(available_categories)
    selected_subcategories = select_subcategories(selected_category)
    q =  Gnomika.get_quotes_for_categories(selected_subcategories)
    puts q
  end
end

Gnomika.main if __FILE__ == $PROGRAM_NAME