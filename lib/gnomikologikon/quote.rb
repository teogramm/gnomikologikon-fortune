module Gnomika
  class Quote
    attr_reader :content, :author

    def initialize(content, author)
      @content = content
      @author = author
    end

    def to_s
      "#{@content}\n  - #{@author}"
    end
  end
end
