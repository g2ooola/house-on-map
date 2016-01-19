# require 'net/http'
# require 'open-uri'
require 'nokogiri'
class ParserYungChing
  HOST='http://buy.yungching.com.tw'

  # def condition
  #   @condition ||= default_condition
  # end

  def search_url
    "#{HOST}/#{search_condition}"
  end

  def start_parse
    # request_arr = []
    result_hash = {}
    begin
      page_info_html = get_html_by_url(search_url)
      page_num = get_page_num(page_info_html)
      raise " !!! get page_num error" if page_num.nil?
      page_num.times do |page|
        # break if page > 0
        puts " === in page #{page + 1}"
        list_page_html = get_html_by_url("#{search_url}?pg=#{page+1}")
        # request_arr += parse_list_page(list_page_html)
        result_hash.merge! parse_list_page(page, list_page_html)

      end
    rescue => e
      puts "  Exception when start parse : #{e}"
    end
    # request_arr
    result_hash
  end

  def parse_and_record(ecxuted_at)
    result_hash = Hash.new(0)
    # result_hash = {success_count: 0, error_count: 0, error_keys: 0}
    # begin
      page_info_html = get_html_by_url(search_url)
      page_num = get_page_num(page_info_html)
      raise " !!! get page_num error" if page_num.nil?
      page_num.times do |i|
        page = i + 1
        puts " === in page #{page}"

        page_url = "#{search_url}?pg=#{page}"
        list_page_html = get_html_by_url(page_url)
        # init_html = list_page_html if page == 0
        # puts " == page url = ||#{page_url}"
        # puts " == list_page_html = #{list_page_html}"
        # puts " init_html == list_page_html #{init_html == list_page_html}"


        page_list_result = parse_list_page(page, list_page_html)
        # puts " == page result = #{page_list_result}"
        # init_page_result = page_list_result if page == 0
        # puts " init_page_result == page_list_result #{init_page_result == page_list_result}"

        # break if page > 2
        # next
        save_result = SourceHouseInfo.seva_parse_result(page_list_result, ecxuted_at)
        result_hash.merge!(save_result) { |key, oldvalue, newvalue| oldvalue + newvalue }
        # break if page > 2
      end
    # rescue => e
    #   puts "  Exception when start parse : #{e}"
    # end

    result_hash
  end
private

  def search_condition
    'region/%E4%BD%8F%E5%AE%85_p/%E5%8F%B0%E5%8D%97%E5%B8%82-%E4%B8%AD%E5%8D%80,%E5%8F%B0%E5%8D%97%E5%B8%82-%E4%B8%AD%E8%A5%BF%E5%8D%80,%E5%8F%B0%E5%8D%97%E5%B8%82-%E6%9D%B1%E5%8D%80,%E5%8F%B0%E5%8D%97%E5%B8%82-%E5%8D%97%E5%8D%80,%E5%8F%B0%E5%8D%97%E5%B8%82-%E8%A5%BF%E5%8D%80_c/-600_price/'
  end

  def get_html_by_url(url)
    begin
      uri = URI(url)
      res = Net::HTTP.get_response(uri)
      return nil unless res.is_a?(Net::HTTPSuccess)

      html = Nokogiri::HTML(res.body).children.at('html')
    rescue => e
      return nil
    end
  end

  def get_page_num(html)
    begin
      last_page_link = html.at_css('.m-pagination-bd li:last-child > a').attr('href')
      path = URI.parse(last_page_link)
      CGI.parse(path.query)["pg"][0].to_i
    rescue => e
      return nil
    end
  end

  def parse_list_page(list_page_index, html)
    house_info_list = html.css('.l-item-list .m-list-item')
    page_list_result = {}
    # puts " ==  p begin #{page_list_result}"
    return nil if house_info_list.nil?
    house_info_list.each_with_index do |house_info, item_index|
      begin
        # puts " === house_info #{house_info}"
        # puts " === house_info.at_css('a') #{house_info.at_css('a')}"
        house_page_path = house_info.at_css('a')['href']
        # puts " === house_page_path #{house_page_path}"
        house_page_url = "#{HOST}#{house_page_path}"
        # puts " === house_page_url #{house_page_url}"

        # puts " === house_page_url -- #{house_page_url}"
        # next

        house_page_info = parse_house_page(house_page_url)
        page_list_result["#{list_page_index}_#{item_index}"] = house_page_info
        # puts house_page_info
      rescue => e
        puts " error on list_page #{list_page}, item #{item_index}, error_mission => #{e}"
      end
    end
    # puts " ==  p af #{page_list_result}"
    page_list_result
  end

  def parse_house_page(house_page_url)
    puts " === house_page_url 11 #{house_page_url}"
    # house_info_hash = {}
    begin
      house_info_hash = {}
      uri = URI(house_page_url)
      res = Net::HTTP.get_response(uri)
      return nil unless res.is_a?(Net::HTTPSuccess)

      html = Nokogiri::HTML(res.body).children.at('html')

      price_text = html.at_css('.house-info-prices .price-num').inner_text
      house_info_hash[:price] = price_text.split('.')[0].gsub(/[^0-9]/,'')


      house_info_sub = html.css('.m-house-info-wrap .house-info-sub')

      float_area_source = house_info_sub[0].at_css('span').inner_text
      house_info_hash[:float_area] = float_area_source.split(/建物(.*)坪/)[1].to_f

      pattern_source = house_info_sub[1].inner_text
      pattern = pattern_source.gsub(/\s+/, "")
      room_num_arr = pattern.split(/(.*)房\(室\)(.*)廳(.*)衛/)
      house_info_hash[:num_of_badroom]    = room_num_arr[1].to_i
      house_info_hash[:num_of_livingroom] = room_num_arr[2].to_i
      house_info_hash[:num_of_restroom]   = room_num_arr[3].to_i

      building_info = house_info_sub[2].css('span')
      house_info_hash[:year]            = building_info[0].inner_text.gsub(/\s+/, "").split(/(.*)年/)[1].to_i
      buliding_format_text = building_info[1].inner_text.gsub(/\s+/, "")
      buliding_format_arr = [buliding_format_text]
      house_info_hash[:buliding_format_id] = building_format_type.try_type(buliding_format_arr)
      house_info_hash[:floor_text] = building_info[2].inner_text.gsub(/\s+/, "")
      house_info_hash[:floor] = house_info_hash[:floor_text].split(/(\d*)\D*.*/)[1].to_i

      # html_house_detail =
      plat_of_land_text = html.at_css('.m-house-detail-list.bg-square .detail-list-lv1 li').inner_text
      house_info_hash[:plat_of_land] = plat_of_land_text.split(/土地坪數：(.*)坪/)[1].to_f

      other_infos = html.css('.m-house-detail-list.bg-other .m-house-detail-ins')[1].css('li')
      other_info_text_arr = other_infos.map { |info| info.inner_text }
      house_info_hash[:material_id] = material_type.try_type(other_info_text_arr)
      # material_text = html.css('.m-house-detail-list.bg-other .m-house-detail-ins')[1].css('li')[1].inner_text
      # material_id = Material.get_format_id(material_text)

      house_info_hash[:address] = html.at_css('.house-info-addr').inner_text

      house_info_hash[:coord_latitude] = html.at_css('#hiddenCenterLat').attr("value").to_f
      house_info_hash[:coord_longitude] = html.at_css('#hiddenCenterLng').attr("value").to_f
      house_info_hash[:parser] = self.class.name
      house_info_hash[:feature_id] = house_page_url.split('/').last
      # HOUSE_INFO_HASH[:ecxuted_at] = Time.now

      # t.integer :year
      # t.integer :floor
      # t.string  :floor_text
      # t.integer :buliding_format_id
      # t.integer :material_id
      # t.float   :plat_of_land
      # t.float   :float_area

      # t.integer :num_of_badroom
      # t.integer :num_of_livingroom
      # t.integer :num_of_restroom

      # t.string  :address
      # t.float   :coord_longitude
      # t.float   :coord_latitude
      house_info_hash[:source_url] = house_page_url
      return house_info_hash
    rescue => e
      puts " error: #{e}"
      house_info_hash[:error_during_parsing] = true
    end
    # house_info_hash
    return nil
  end

  def building_format_type
    @building_format_type ||= BuildingFormatType.new
  end

  def material_type
    @material_type ||= MaterialType.new
  end
end
