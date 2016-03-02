class Api::V1::OrganisationsController < ApplicationController
  before_action :authenticate_with_token!
  load_and_authorize_resource

  def index
    render json: @organisations,
           each_serializer: OrganisationsSerializer,
           status: 200
  end

  def show
    render json: @organisation, status: 200
  end

  def create
  end

  def update
  end

  def destroy
  end
end
