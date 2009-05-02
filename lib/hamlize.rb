class Hamlize
  
  attr_accessor :options
  attr_reader :hamlize_result, :sassize_result, :successful_files, :failed_files
  
  class HamlizeError < StandardError; end
  
  def initialize(paths = '.', opt = {})
    @options = opt
    @options[:hamlize_extensions] ||= [:erb, :rhtml, :html]
    @options[:sassize_extensions] ||= [:css]
    @options[:recursive] = true if @options[:recursive].nil?
    @options[:ignore_vendor] = true if @options[:ignore_vendor].nil?
    @options[:with_output] = false if @options[:with_output].nil?
    @options[:delete_after_conversion] = false if @options[:delete_after_conversion].nil?
    @options.merge!(:paths => paths.to_a)
  end
  
  def convert!(to = [:haml, :sass])
    hamlize! if to.include?(:haml)
    sassize! if to.include?(:sass)
  end
  
  def hamlize!(with_output = false)
    puts "--------------------------------------"
    puts " Convert to HAML"
    puts "--------------------------------------"
    begin
      query = build_file_match_expression(@options[:paths], @options[:hamlize_extensions], @options[:recursive])
      Dir.glob(query).each do |file|
        Hamlize.html2haml!(file) unless @options[:ignore_vendor] && file.match(/vendor\/[\w]+/)
      end
      @hamlize_result = true
    rescue StandardError => e
      puts "Error: #{e}"
      @hamlize_result = false
    end
  end
  
  def sassize!(with_output = false)
    puts "--------------------------------------"
    puts " Convert to SASS"
    puts "--------------------------------------"
    begin
      query = build_file_match_expression(@options[:paths], @options[:sassize_extensions], @options[:recursive])
      Dir.glob(query).each do |file|
        Hamlize.css2sass!(file) unless @options[:ignore_vendor] && file.match(/vendor\/[\w]+/)
      end
      @sassize_result = true
    rescue
      @sassize_result = false
    end
  end
  
  def result(from = [:haml, :sass])
    @result = true
    @result &= @hamlize_result if from.include?(:haml)
    @result &= @sassize_result if from.include?(:sass)
  end
  
  def self.html2haml!(source_file, with_output = false)
    destination_file = File.join(File.dirname(source_file), "#{File.basename(source_file, '.*')}.haml")
    `html2haml -rx #{source_file} #{destination_file}`
    Hamlize.log_file_conversion(source_file, destination_file)
  end
  
  def self.css2sass!(source_file, with_output = false)
    destination_file = File.join(File.dirname(source_file), "#{File.basename(source_file, '.*')}.sass")
    `css2sass #{source_file} #{destination_file}`
    Hamlize.log_file_conversion(source_file, destination_file)
  end
  
  private
  
  def build_file_match_expression(paths, extensions, recursive = true)
    file_match_string = match_filter(paths)
    file_match_string = File.join(file_match_string, '**') if recursive
    file_match_string = File.join(file_match_string, "*.#{match_filter(extensions)}")
  end
  
  def match_filter(string_literals, method = :pattern)
    if method.to_sym == :regex
      "(#{string_literals.to_a * '|'})"
    else
      "{#{string_literals.to_a * ','}}"
    end
  end
  
  def self.log_file_conversion(source_file, destination_file)
    if File.exist?(destination_file)
      puts "** Successfully generated: #{destination_file} (from #{source_file})"
    else
      puts "** Failed to generate: #{destination_file} (from #{source_file})"
      raise HamlizeError.new("Failed to convert #{source_file}.")
    end
  end
  
end
