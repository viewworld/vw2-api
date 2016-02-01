class Api::V1::SessionsController < ApplicationController
  before_action :authenticate_with_token!, only: :destroy
  def create
    user_login = params[:login]
    user_password = params[:password]

    user = User.find_by(email: user_login)
    user ||= User.find_by(login: user_login)

    if user && user.authenticate(user_password)
      auth_token = user.set_auth_token
      render json: user, token: auth_token, status: 200
    else
      render json: { error: 'user not found' }
    end
  end

  def destroy
    $redis.del(request.headers["Authorization"])
    head 204
  end
end

