class Api::V1::ReportsController < ApplicationController
  before_action :find_form, only: :create
  before_action :find_report, only: [:show, :update, :destroy]

  wrap_parameters format: :json

  # GET /forms/:id/reports
  def index
    reports = Report.all
    render json: reports, status: 200
  end

  # GET /forms/:id/reports/:id
  def show
    render json: @report, status: 200
  end

  # POST /forms/:id/reports
  def create
    report = @form.reports.create(report_params)
    # full_data = {}
    # report.data.each { |k, v| full_data[k]=v.merge(@form.data[k]) }
    # report.data = full_data
    if report.save
      render json: report, status: 200
    else
      render json: { errors: report.errors }, status: 422
    end
  end

  # PATCH /forms/:id/reports/:id
  def update
    if @report && report.update(report_params)
      render json: @report, status: 200
    else
      render json: { errors: 'error' }, status: 422
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

  def find_report
    @report = Report.find(params[:id])
  end

  def find_form
    @form = Form.find(params[:form_id])
  end
end
