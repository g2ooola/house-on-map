class Api::SearchApiController < ApplicationController
  respond_to :json
  def test
    zoom = params[:zoom].to_i
    lat = params[:lat].to_f
    lng = params[:lng].to_f
    grid_tool = GridTool.new
    result = grid_tool.test(zoom, lat, lng)
    puts " =============== result #{result}"

    respond_with result, status: :ok
  end
end