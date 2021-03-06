class SourceHouseInfo < ActiveRecord::Base
  # source_house_infos

  scope :unmerge_sources,-> { where(is_marged: false) }

  def self.seva_parse_result(parse_result_hash, ecxuted_at, rewrite = true)
    # puts " =============== seva_parse_result"
    # puts " =============== parse_result_hash.keys #{parse_result_hash.keys}"
    error_page = []
    success_count = 0
    ecxuted_date = ecxuted_at.to_date
    parse_result_hash.each do |key, parse_result|
      # puts " =============== key #{key}"
      # puts " =============== parse_result #{parse_result}"

      if parse_result.nil?
        error_page.push key
        # puts "key #{key} null"
        next
      end
      source_hash = parse_result.merge({ecxuted_at: ecxuted_at, ecxuted_date: ecxuted_date})
      # puts " =============== source_hash #{source_hash}"
      if rewrite
        s = SourceHouseInfo.find_or_initialize_by(parser: source_hash[:parser], feature_id: source_hash[:feature_id], ecxuted_date: source_hash[:ecxuted_date])
        save_ok = s.update(source_hash)
      else
        s = SourceHouseInfo.new(source_hash)
        save_ok = s.save
      end
      # puts " =============== s #{s}"
      if save_ok
        success_count += 1
        next
      else
        error_page.push key
        # puts "  save to data source error on #{key}"
      end
    end
    { total_sount: parse_result_hash.length, success_count: success_count, error_count: error_page.length, error_keys: error_page }
  end

  def marged!
  end

  # {
  #   :price=>"598",
  #   :float_area=>22.3,
  #   :num_of_badroom=>4,
  #   :num_of_livingroom=>2,
  #   :num_of_restroom=>3,
  #   :year=>0,
  #   :buliding_format_id=>1,
  #   :floor_text=>"1~2/2樓",
  #   :floor=>1,
  #   :plat_of_land=>12.7,
  #   :material_id=>nil,
  #   :address=>"台南市中西區西寧街",
  #   :coord_latitude=>22.997668194771,
  #   :coord_longitude=>120.190672202377,
  #   :source_url=>"http://buy.yungching.com.tw/house/1426022"
  # }
end
