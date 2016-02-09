class Api::V1::ReportsController < ApplicationController
  before_action :authenticate_with_token!
  load_and_authorize_resource :form
  load_and_authorize_resource :report, through: :form

  # GET /forms/:id/reports
  def index
    render json: @reports, status: 200
  end

  # GET /forms/:id/reports/:id
  def show
    render json: @report, status: 200
  end

  # POST /forms/:id/reports
  def create
    if @report.save
      render json: @report, status: 201
    else
      render json: { errors: @report.errors }, status: 422
    end
  end

  # PATCH /forms/:id/reports/:id
  def update
    if @report && @report.update(report_params)
      render json: @report, status: 200
    else
      render json: { errors: @report.errors }, status: 422
    end
  end

  # DELETE /forms/:id/reports/:id
  def destroy
    @report.destroy
    head 204
  end

  private

  def report_params
    params.require(:report).permit(:data, :form_id).tap do |whitelisted|
      data = params[:report][:data]
      whitelisted[:data] = data if data
    end
  end
end
