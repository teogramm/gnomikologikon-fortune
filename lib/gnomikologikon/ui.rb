module Gnomika
  ##
  # Prompt the user to select a category
  # @param categories Array of Category objects
  # @return The Category object the user selected
  def self.select_category(categories)
    # Index starting from 1
    categories.each_with_index { |category, index| puts "#{index+1}. #{category.name}" }
    ok = false
    num = -1
    until ok
      print "Select a category: "
      STDOUT.flush
      input =  STDIN.gets
      begin
        # Remove 1 because display indexes starting from 1.
        num = Integer(input) - 1
        break unless num < 0 || num > categories.length-1
        puts "Invalid selection!"
      rescue ArgumentError
        puts "Invalid selection!"
      end
    end
    # Return Category object chosen by the user
    categories[num]
  end
end