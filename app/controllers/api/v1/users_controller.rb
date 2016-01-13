class Api::V1::UsersController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_with_token!

  def index
    users = User.all
    render json: users, status: 200
  end

  def show
    user = User.find(params[:id])
    render json: user, status: 200
  end
end
