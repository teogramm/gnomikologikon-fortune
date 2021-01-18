# frozen_string_literal: true

require "nokogiri"
require "httparty"
require "gnomikologikon/category"
require "gnomikologikon/quote"
require "ruby-progressbar"

module Gnomika
  ##
  # Gets information about all categories from the website
  # @return An Array of Category objects
  def self.fetch_category_info
    response = HTTParty.get('https://www.gnomikologikon.gr/categ.php', {
      headers: {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"},
    })

    doc = Nokogiri::HTML.parse(response.body)
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

  ##
  # Get all quotes for the given subcategories
  # @yield Runs the given block after each subcategory is processed
  # @param subcategories Array of subcategories
  # @return Hash matching each subcategory to an Array of quotes
  def self.get_quotes_for_categories(subcategories)
    quotes = {}
    subcategories.each do |subcategory|
      response = HTTParty.get(subcategory.url, {
        headers: {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"},
      })
      quotes[subcategory] = get_quotes_from_html(response.body)
      yield if block_given?
      # Throttle the connection because processing is fast
      sleep 1
    end
    quotes
  end

  ##
  # Fetch all quotes from given HTML page
  # @param page_body Body of HTML page to extract quotes from
  # @return Array of quotes
  def self.get_quotes_from_html(page_body)
    doc = Nokogiri::HTML.parse(page_body)
    quotes_tables = doc.xpath("//table[@class='quotes']//td[@class='quote']")
    quotes = []
    quotes_tables.each do |quote|
      # Get quote contents
      content = quote.at_xpath("./text()").text
      # Check if there is an explanation
      explanation = quote.xpath("./table[@class='expth']//td")
      unless explanation.empty?
        # If an explanation exists, there are two td elements
        # Remove pavla
        explanation = explanation.reject{|element| element["class"] == "pavla"}
        # Keep the explanation td element
        explanation = explanation[0]
        content << "\n(#{explanation.text})"
      end
      # Check if there is a comment
      comment = quote.xpath("./p[contains(@class, 'comnt')]")
      unless comment.nil?
        # Do not add comment if it does not contain text
        content << "\n#{comment.text}" unless comment.text.empty?
      end
      # HTML p elements with class auth0-auth4 contain quote author and additional information (e.g. book)
      # Get the text of all auth p elements and combine them in a string
      author = quote.xpath(".//p[contains(@class, 'auth')]")
      author = author.map{|el| el.text}.join(' ')
      quotes << Quote.new(content,author)
    end
    quotes
  end
end
