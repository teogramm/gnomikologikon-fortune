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
        # Input was number but out of bounds
        puts "Invalid selection!"
      rescue ArgumentError
        # Input could not be converted to integer
        puts "Invalid selection!"
      end
    end
    # Return Category object chosen by the user
    categories[num]
  end

  ##
  # Prompt user to select subcategories. Selection can be a range e.g. 1-2, single categories e.g. 1,2,3 or both
  # e.g 1,2-4
  # @param category The Category that will be shown
  # @return Array of selected Subcategory objects
  def self.select_subcategories(category)
    subcategories = category.subcategories
    # Index starting from 1
    subcategories.each_with_index { |subcategory, index| puts "#{index+1}. #{subcategory.name}" }
    puts "You can select multiple categories separated by ',' or a range of categories with '-'."

    # Contains indexes of all subcategories specified by the user
    selected_indexes = []
    ok = false
    until ok
      print "Select subcategories: "
      # On each loop we assume input is ok until an error is encountered
      ok = true
      # Empty the indexes array, in case of leftovers from previous loop
      selected_indexes = []
      input = STDIN.gets
      # Split the input
      input = input.split(",")
      # Check each selection
      input.each do |selection|
        begin
          # We need to remove 1 from each because during selection category numbers started from 1
          selected_indexes += selection_to_array(selection, subcategories.length).map{|it| it - 1}
        rescue => error
          ok = false
          puts error.message
          break
        end
      end
    end
    # Remove any duplicate indexes
    selected_indexes.uniq!
    # Create an array with the corresponding Subcategory objects and return it
    selected_indexes.map { |index| subcategories[index]}
  end

  private

  ##
  # Converts given selection into an array of indexes.
  # Throws an ArgumentError if the selection is invalid. An error message is included in the exception.
  # This function must be used with a single selection (e.g 3 or 3-5), not with a list of many selections (e.g 1,2,3...)
  # @param selection String of the selection
  # @param max_available_index Used w
  # @return Array of indexes included in the selection
  def self.selection_to_array(selection, max_available_index)
    # Check if selection is a range
    if selection.include?("-")
      # Try to process it as a range
      range_start, range_end = selection.split("-")
      begin
        range_start = Integer(range_start)
        range_end = Integer(range_end)
        # Check if range is correct. Start must be smaller or equal than end and end must be smaller or equal
        # to max_available index
        if range_start > range_end || range_end > max_available_index || range_start < 1
          raise ArgumentError
        end
        return (range_start..range_end).to_a
      rescue ArgumentError
        raise ArgumentError.new "Invalid range! (#{selection.strip})"
      end
    else
      # Assume selection is an integer
      begin
        number = Integer(selection)
        # Check limits
        if number < 1 || number > max_available_index
          raise ArgumentError
        end
        return [number]
      rescue
        raise ArgumentError.new "Invalid selection! (#{selection.strip})"
      end
    end
  end
end