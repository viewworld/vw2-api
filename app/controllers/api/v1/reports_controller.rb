class Api::V1::ReportsController < ApplicationController
  before_action :find_form, only: :create

  def index
    reports = Report.all
    render json: reports, status: 200
  end

  def show
    report = Report.find(params[:id])
    render json: report, status: 200
  end

  def create
    report = @form.reports.create(report_params)
    full_data = {}
    report.data.each { |k, v| full_data[k]=v.merge(@form.data[k]) }
    report.data = full_data
    if report.save
      render json: report, status: 200
    else
      render json: { errors: 'error' }
    end
  end

  def update
    report = @form.reports.find_by(id: params[:id])
    if report && report.update(report_params)
      render json: report, status: 200
    else
      render json: { errors: 'error' }, status: 422
    end
  end

  private

  def report_params
    params.permit(:data, :form_id)
  end

  def find_form
    @form = Form.find(params[:form_id])
  end
end
