class HouseMapsController < ApplicationController
  layout 'house_maps_layout'
  def index
  end

  def check
    permitted = params.permit(:main_date, :check_date)

    @default_main_date = params[:main_date].present? ? params[:main_date].to_date : Time.now.to_date

    # puts " === params[:check_date]          #{params[:check_date]} "
    # puts " === params[:check_date].present? #{params[:check_date].present?} "
    # puts " === params[:check_date].to_date  #{params[:check_date].to_date} "
    # puts " === 1.days.ago.to_date           #{1.days.ago.to_date} "

    @default_check_date = params[:check_date].present? ? params[:check_date].to_date : 1.days.ago.to_date

    # @default_main_date = (params[:main_date] || Time.now.to_date)
    # @default_check_date = (params[:check_date] || 1.days.ago.to_date)
    @sources = {}
    @all_date = []

    @sources, @all_date = Comparer.new.check(@default_main_date, @default_check_date)
    # if permitted[:main_date].present? && permitted[:check_date].present?
    #   @sources, @all_date = Comparer.new.check(:main_date, :check_date)
    # end

  end

  def test
    # redirect_to 'https://play.google.com/store/apps/details?id=com.kdanmobile.android.animationdesk'
    # redirect_to 'https://itunes.apple.com/app/id914548793'
  end
end
