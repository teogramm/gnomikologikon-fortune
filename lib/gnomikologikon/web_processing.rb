# frozen_string_literal: true

require "nokogiri"
require "httparty"
require "gnomikologikon/category"

module Gnomika
  ##
  # Gets information about all categories from the website
  # @return An Array of Category objects
  def self.fetch_category_info
    # response = HTTParty.get('http://example.com', {
    #   headers: {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"},
    # })


    doc = Nokogiri::HTML.parse(open("categ.php"))
    # Each "big" category is stored in a table with class "authrst"
    category_tables = doc.xpath("//table[@class='authrst']")

    categories = []

    category_tables.each do |table|
      # Get category name. Category names are stored in td elements with class "authrsh"
      category_name = table.xpath("tr/td[@class='authrsh']").text

      # Get the subcategories of each category
      subcategories = []
      # Subcategories of each category are a elements in a list
      subcategory_elements = table.xpath("tr//ul//li//a")
      subcategory_elements.each do |element|
        subcategory_name = element.content
        # Need to prefix category URLs with the website URL
        subcategory_url = "https://www.gnomikologikon.gr/#{element[:href]}"
        subcategories << Subcategory.new(subcategory_name,subcategory_url)
      end

      categories << Category.new(category_name,subcategories: subcategories)
    end
    categories
  end
end
