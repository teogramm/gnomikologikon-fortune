# frozen_string_literal: true

require_relative 'version'

module Gnomika
  ##
  # Class used to parse command line arguments
  class ArgParser

    ##
    # Contains the application options
    class GnomikaOptions
      attr_accessor :custom_output_dir_set, :custom_output_dir_value, :single_file, :single_file_name, :list_only

      def initialize
        self.custom_output_dir_set = false
        self.custom_output_dir_value = ""
        self.single_file = false
        self.single_file_name = ""
      end
    end

    ##
    # Parses the given option into a struct
    # @param arguments Array of parameters given to the program
    # @return A GnomikaOptions object
    def self.parse(arguments)
      options = GnomikaOptions.new
      parser = create_parser(options)
      parser.parse(arguments)
      options
    end

    class << self
      private

      ##
      # Creates a parser that places values in the given object
      # @param options The object to place the values in
      def create_parser(options)
        parser = OptionParser.new

        parser.on "-o DIR", "--output-dir DIR", "Specify custom output directory" do |value|
          options.custom_output_dir_set = true
          options.custom_output_dir_value = value
        end
        parser.on "-s [FILENAME]", "--single-file [FILENAME]", "Output all quotes in a single file" do |name|
          options.single_file = true
          options.single_file_name = name
        end
        parser.on "-l", "--list-categories", "List all available categories" do
          options.list_only = true
        end

        parser.on "-h", "--help", "Print this help text" do
          puts parser
          exit
        end

        parser.on "-v", "--version", "Print program version" do
          puts "gnomikologikon-fortune #{Gnomika::Ruby::VERSION}"
          exit
        end
      end
    end

  end
end
