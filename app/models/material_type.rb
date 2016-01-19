# require 'fileutils'
class MaterialType < ActiveRecord::Base
  RECODE_FILE_PREFIX = 'unknown_material'
  RECODE_FILE_PATH   = 'recode'
  RECODE_START_STRING =  'unknow materials info below : '
  def try_type(text_arr)
    possible_type_hash = self.class.all_types
    text_arr.each do |text|
      possible_type_hash.each do |possible_type|
        return possible_type[:id] unless text[possible_type[:category]].nil?
      end
    end
    record_unknown_category(text_arr)
    return nil
  end

  def self.all_types
    @all_types ||= self.all.map{ |type| {category: type.category, id: type.id} }
  end

  def record_unknown_category(text_arr)
    recode_string = "#{self.class.recode_start_strgin}\n"
    text_arr.each { |text| recode_string << "  #{text}\n" }
    recode_string << "\n\n\n"

    # logger.info recode_string

    # dir_name = File.dirname(self.class.recode_file_path)
    # unless File.directory?(dir_name)
    #   FileUtils.mkdir_p(dir_name)
    # end

    unless File.directory?(self.class.recode_file_path)
      FileUtils.mkdir_p(self.class.recode_file_path)
    end

    out_file = File.new(self.class.record_file_name, "a")
    out_file.puts recode_string
    out_file.close

  end

  def logger
    @logger ||= Logger.new(self.class.record_file_name)
  end

  def self.record_file_name
    "#{recode_file_path}/#{recode_file_prefix}_#{Time.now.strftime('%Y%m%d')}.txt"
  end

  def self.recode_file_prefix
    RECODE_FILE_PREFIX
  end

  def self.recode_file_path
    RECODE_FILE_PATH
  end

  def self.recode_start_strgin
    RECODE_START_STRING
  end
end
