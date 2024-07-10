module Users
  class EncodeJsonWebToken < ApplicationService
    attr_reader :payload

    SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

    def initialize(payload:)
      @payload = payload
    end

    def call
      payload[:exp] = 24.hours.from_now.to_i
      token = JWT.encode(payload, SECRET_KEY)
      return [:success, token]
    end
  end
end