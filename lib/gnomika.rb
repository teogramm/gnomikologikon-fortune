# frozen_string_literal: true

require "gnomikologikon/ui"
require "gnomikologikon/arg_parser"
require "gnomikologikon/web_processing"
require "gnomikologikon/file_writer"
require "optparse"

##
# Module containing all classes and functions of the application
module Gnomika
  def self.main
    # Parse command line arguments
    options = ArgParser.parse(ARGV)
    # Get available categories
    available_categories = Gnomika.fetch_category_info
    # Prompt user to select a category
    selected_category = select_category(available_categories)
    # Prompt user to select subcategories
    selected_subcategories = select_subcategories(selected_category)
    # Create a progress bar
    progressbar = ProgressBar.create(total: selected_subcategories.length, title: "Download Progress")
    # Get the quotes and display progress
    quotes =  Gnomika.get_quotes_for_categories(selected_subcategories){
      progressbar.increment
    }
    # Create quote files with the options given as parameters
    begin
      write_files(options, quotes)
    rescue StandardError => e
      STDERR.puts e.message
    end
  end
end

Gnomika.main if __FILE__ == $PROGRAM_NAME