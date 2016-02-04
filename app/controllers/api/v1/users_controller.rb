class Api::V1::UsersController < ApplicationController
  #load_and_authorize_resource
  before_action :authenticate_with_token!

  def index
    render json: @users, status: 200
  end

  def show
    render json: @user, status: 200
  end
end

