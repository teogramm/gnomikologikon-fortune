module Gnomika

  ##
  # Writes given quotes to files according to the given options.
  # @param options GnomikaOptions object containing file output options
  # @param quotes Hash matching each subcategory to an Array with quotes
  def self.write_files(options, quotes)
    # If no custom directory is specified, use the current directory
    output_directory = Dir.pwd
    if options.custom_output_dir_set
      custom_dir = options.custom_output_dir_value
      begin
        unless Dir.exist? custom_dir
          Dir.mkdir custom_dir
        end
        output_directory = custom_dir
      rescue StandardError => e
        raise e
      end
    end
    file_writer = FileWriter.new(output_directory, options.single_file, single_file_name: options.single_file_name)
    quotes.each_pair do |subcategory,subcategory_quotes|
      file_writer.write_quotes(subcategory.name,subcategory_quotes)
    end
    # Must generate strfiles for fortune command to work
    file_writer.generate_strfiles
  end

  ##
  # FileWriter is responsible for writing quotes to files
  class FileWriter
    ##
    # @param output_directory Path to directory that the files will be stored, must already exist
    # @param single_file true if all quotes will be written in a single file
    # @param single_file_name Name of the single file
    def initialize(output_directory, single_file, single_file_name: "gnomika")
      @output_directory = output_directory
      @single_file_mode = single_file
      @files_written = []
      # If single file output is specified, create the file now and use it in all future writes
      if single_file
        single_file_path = "#{output_directory}/#{single_file_name}"
        @single_file = File.new(single_file_path,File::CREAT|File::TRUNC|File::WRONLY)
        @files_written << single_file_path
      end
    end

    ##
    # Writes the given quotes to the file.
    # @param quotes Array of quotes to write
    def write_quotes(subcategory_name, quotes)
      # If single file output is used, use the existing file. Otherwise create a new one for this category
      file = if @single_file_mode
               @single_file
             else
               # Write filename in files_written array
               new_file_name = "#{@output_directory}/#{subcategory_name}"
               @files_written << new_file_name
               File.new(new_file_name,File::CREAT|File::TRUNC|File::WRONLY)
             end
      # Write quotes separated by "%" sign
      file.write(quotes.join("\n%\n"))
    end

    ##
    # Runs the strfile command for every written file.
    def generate_strfiles
      until @files_written.empty?
        file_path = @files_written.shift
        system("strfile",file_path)
      end
    end
  end
end