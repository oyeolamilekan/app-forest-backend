class ApplicationController < ActionController::API
  rescue_from StandardError, with: :render_error_response
  
  attr_reader :current_user

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = Users::DecodeJsonWebToken.call(token: header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { status: false, message: "Invalid token", data: nil }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { status: false, message: "Invalid token", data: nil }, status: :unauthorized
    end
  end

  def api_response(status:, message:, data:, status_code: nil, meta: nil)
    response = {
      status: status,
      message: message,
      data: data
    }

    response[:meta] = meta if meta.present?

    return render json: response, status: status_code || :ok
  end

  def render_error_response(exception)

    Rails.logger.error("An exception occurred: #{exception.message}")

    if Rails.env.production?
        return api_response(status: false, message: "500 server error.", data: nil, status_code: :internal_server_error)
    else
        raise exception
    end
  end
end
