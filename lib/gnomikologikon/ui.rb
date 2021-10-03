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
  # Converts given selection into an array of integers.
  # Throws an ArgumentError if the selection is invalid. An error message is included in the exception.
  # This function must be used with a single selection (e.g 3 or 3-5), not with a list of many selections (e.g 1,2,3...)
  # @param selection_string String of the selection
  # @param max_available_index Maximum allowed value
  # @return Array with the selected items
  def self.selection_to_array(selection_string, max_available_index)
    selection = []
    # Check if selection is a range
    begin
      if selection_string.include?("-")
        # Try to process it as a range
        selection = process_range(selection_string,max_available_index)
      else
        # Assume selection is an integer
        number = Integer(selection_string)
        # Check limits
        if number < 1 || number > max_available_index
          raise ArgumentError.new "Invalid selection! (#{selection_string.strip})"
        end
        selection = [number]
      end
    rescue ArgumentError => e
      raise e
    end
    selection
  end

  ##
  # Tries to convert given string to a range of integers. Input string must be of the form a-b
  # @param upper_limit Maximum allowed value
  # @return Array of integers in the range
  # @raise ArgumentError if given selection string is not a valid range
  def self.process_range(selection_string, upper_limit)
    range_start, range_end = selection_string.split("-")
    range_start = Integer(range_start)
    range_end = Integer(range_end)
    # Check if range is correct. Start must be smaller or equal than end and end must be smaller or equal
    # to upper_limit
    unless is_valid_range?(range_start,range_end,upper_limit)
      raise ArgumentError.new "Invalid range! (#{selection_string.strip})"
    end
    (range_start..range_end).to_a
  end

  ##
  # Checks if a range with the given parameters is valid. A range is valid if:
  # 1. start <= end
  # 2. end <= upper_limit
  # 3. start > 0
  def self.is_valid_range?(range_start,range_end,upper_limit)
    not (range_start > range_end || range_end > upper_limit || range_start < 1)
  end
end
