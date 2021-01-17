
module Gnomika
  ##
  # A quote category. Has many subcategories
  class Category
    attr_reader :subcategories, :name

    ##
    # @param category_name Category name
    # @param subcategories Array of subcategories included in category. Is an empty array, if omitted
    def initialize(category_name, subcategories: [])
      @name = category_name
      @subcategories = subcategories
    end
  end

  ##
  # A quote subcategory. Has a name and a URL to the quotes page.
  class Subcategory
    attr_reader :name, :url

    ##
    # @param subcategory_name Subcategory name
    # @param subcategory_url URL containing the quotes of this subcategory
    def initialize(subcategory_name, subcategory_url)
      @name = subcategory_name
      @url = subcategory_url
    end
  end
end
