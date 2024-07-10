class UsersController < ApplicationController
  before_action :authorize_request, except: [
    :login, 
    :sign_up, 
  ]

  def sign_up
    status, user = Users::CreateUser.call(user_params: create_user_params)
    return api_response(status: true, message: "Successfully created user", data: nil, status_code: :created) if status == :success
    api_response(status: false, message: user, data: nil, status_code: :unprocessable_entity)
  end

  def login
    status, user = Users::GetUser.call(user_attribute: { email: params[:email] })
    if user && user.authenticate(params[:password])
      api_response(status: true, message: "Successfully Logged in", data: user.as_json, status_code: :ok)
    else
      api_response(status: false, message: "Error in authenticating user, kindly check your credentials", data: nil, status_code: :unprocessable_entity)
    end
  end

  def change_password
    if !current_user.authenticate(change_password_params[:old_password])
      return api_response(status: false, message: "Old password don't match.", data: nil, status_code: :unprocessable_entity)
    end

    if change_password_params[:password] != change_password_params[:password2]
      return api_response(status: false, message: "Passwords don't match.", data: nil, status_code: :unprocessable_entity)
    end

    if current_user.update({password: change_password_params[:password]})
      return api_response(status: true, message: "User password has been change.", data: nil, status_code: :ok)
    end

    api_response(status: false, message: "Failed in changing password", data: nil, status_code: :unprocessable_entity)
  end

  private
  def create_user_params
    params.permit(:email, :first_name, :last_name, :password)
  end

  def change_password_params
    params.permit(:old_password, :password, :password2)
  end
end
