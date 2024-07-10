module Users
  class GetUser < ApplicationService
    attr_reader :user_attribute

    def initialize(user_attribute:)
      @user_attribute = user_attribute
    end

    def call
      user = User.find_by(user_attribute)
      return [:success, user]
    end
  end
end