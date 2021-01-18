module Gnomika
  class Quote
    attr_reader :content, :author

    def initialize(content, author)
      @content = content
      @author = author
    end

    def to_s
      str = "#{@content}"
      str << "\n  - #{@author}" unless @author.strip.empty?
      str
    end
  end
end
