# require 'source_house_infos'
class Recorder

  def start_record
    get_source_house_info()
    update_house_info()
  end
  def get_source_house_info()
    parser_class_array = [ParserYungChing]
    ecxuted_at = Time.now
    save_result = {}
    parser_class_array.each do |parser_class|

      parser = parser_class.new
      parse_result_hash = parser.start_parse
      save_result[parser_class.name] = SourceHouseInfo.seva_parse_result(parse_result_hash, ecxuted_at)
    end
    save_result.each do |parser_name, save_result|
      puts " == #{parser_name} result :  "
      puts "     success_count: #{save_result[:success_count]}"
      puts "     error_count:   #{save_result[:error_count]}"
      puts "     error_items:   #{save_result[:error_keys]}"
      puts ""
    end
  end

  def update_house_info
    SourceHouseInfo.unmerge_sources.find_each do |source_house_info|
      HouseInfo.update_using_source( source_house_info)
    end
  end
end