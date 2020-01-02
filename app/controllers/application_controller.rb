class ApplicationController < ActionController::API

  before_action :test
  # before_action :authorize_request

  def test
  	puts 'API Working'
  	render json: 'API Working'
  end

  private

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)

      @current_user = User.find_by_email(@decoded[:user_email])

    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { error: e.message }, status: :unauthorized
    end
  end

end