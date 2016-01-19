class Api::SearchApiController < ApplicationController
  respond_to :json
  def latlng
    result = nil
    begin
      zoom = params[:zoom].to_i
      lat = params[:lat].to_f
      lng = params[:lng].to_f

      position_search = PositionSearch.new
      id_lat, id_lng = position_search.index_calcul_by_zoom(lat, lng, zoom)
      house_infos = position_search.house_around_index(zoom, id_lat, id_lng)

      result = { response_code: 200, data: {house_infos: house_infos}, message: 'Get index success.'}
    rescue Exception => e
      logger.info " API TEST ERROR : #{e}"
    end

    result ||= { response_code: 400, data: nil, message: 'Something error.'}
    respond_with result, status: :ok
  end

# private
#   def response_success(code, data, message)
#     result = {code: code, data: data, message: message}
#     respond_with result, status: :ok
#   end
#
#   def response_error(code, date, message)
#     result = {code: code, data: data, message: message}
#     respond_with result, status: :400
#   end

end
