module Users
  class LoginUser < ApplicationService
    attr_reader :email, :password

    def initialize(email:, password:)
      @email = email
      @password = password
    end

    def call
      user = Users::GetUser.call(user_attribute: { email: email })
      return [:success, user] if user && user.authenticate(password)
      return [:failed, "Error in authenticating user"]
    end
  end
end