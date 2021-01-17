# frozen_string_literal: true

require_relative "gnomikologikon/arg_parser"
require "optparse"

##
# Module containing all classes and functions of the application
module Gnomika
  def self.main
    options = ArgParser.parse(ARGV)
  end
end

Gnomika.main if __FILE__ == $PROGRAM_NAME
