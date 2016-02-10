class Api::V1::ReportFilesController < ApplicationController
  before_action :authenticate_with_token!
  load_and_authorize_resource

  def show
    render json: @report_file, status: 200
  end

  def create
    if @report_file.save
      render json: @report_file, status: 201
    else
      render json: { errors: @report_file.errors }, status: 422
    end
  end

  private

  def report_file_params
    params.permit(:file)
  end
end
