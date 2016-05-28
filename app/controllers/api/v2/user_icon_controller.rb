class Api::V2::UserIconController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json
  def set_user_icon
    puts " === === params #{params}"
    # result = { response_code: 200, data: 'nil', message: 'maby ok.'}
    render json: {status: 'maby ok'}
    # respond_with result, status: :ok
  end
end