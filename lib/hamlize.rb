class Hamlize
  
  attr_accessor :options
  attr_reader :hamlize_result, :sassize_result, :successful_files, :failed_files
  
  class HamlizeError < StandardError; end
  
  def initialize(paths = '.', options = {})
    options[:hamlize_extensions] ||= [:erb, :rhtml, :html]
    options[:sassize_extensions] ||= [:css]
    options[:recursive] = true if options[:recursive].nil?
    options[:ignore_vendor] = true if options[:ignore_vendor].nil?
    options[:with_output] = false if options[:with_output].nil?
    options[:delete_after_conversion] = false if options[:delete_after_conversion].nil?
    options.merge(:paths => paths.to_a)
  end
  
  def convert!(to = [:haml, :sass])
    hamlize! if to[:haml]
    sassize! if to[:sass]
  end
  
  def hamlize!(with_output = false)
    begin
      query = build_file_match_expression(options[:paths], options[:hamlize_extensions], @options[:recursive])
      Dir[file_match_string].each do |file|
        html2haml!(file) unless file.match(/vendor\/[\w]+/)
      end
      @hamlize_result = true
    rescue
      @hamlize_result = false
    end
  end
  
  def sassize!(with_output = false)
    begin
      query = build_file_match_expression(options[:paths], options[:sassize_extensions], @options[:recursive])
      Dir[query].each do |file|
        html2haml!(file) unless file.match(/vendor\/[\w]+/)
      end
      @sassize_result = true
    rescue
      @sassize_result = false
    end
  end
  
  def self.html2haml!(source_file, with_output = false)
    destination_file = "#{File.basename(file, '.*')}.haml"
    `html2haml -rx #{source_file} #{destination_file}`
    log_file_conversion(source_file, destination_file)
  end
  
  def self.css2sass!(source_file, with_output = false)
    destination_file = "#{File.basename(file, '.*')}.sass"
    `css2sass -rx #{source_file} #{destination_file}`
    log_file_conversion(source_file, destination_file)
  end
  
  def result(from = [:haml, :sass])
    @result = true
    @result &= @hamlize_result if from.include?(:haml)
    @result &= @sassize_result if from.include?(:sass)
  end
  
  private
  
  def log_file_conversion(source_file, destination_file)
    if File.exist?(destination_file)
      "** Successfully generated: #{destination_file} (from #{source_file})"
    else
      "** Failed to generate: #{destination_file} (from #{source_file})"
      raise HamlizeError.new("Failed to convert #{source_file}.")
    end
  end
  
  def build_file_match_expression(paths, extensions, recursive = true)
    file_match_string = match_filter(options[:paths])
    file_match_string = File.join(search_string, '**') if recursive == true
    file_match_string = File.join(search_string, "*.#{match_filter(options[:hamlize_extensions])}")
  end
  
  def match_filter(string_literals, method = :pattern)
    if method.to_sym == :regex
      "(#{string_literals.to_a * '|'})"
    else
      "{#{string_literals.to_a * ','}}"
    end
  end
  
end
