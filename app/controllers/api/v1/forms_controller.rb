class Api::V1::FormsController < ApplicationController
  def index
    forms = Form.all
    render json: forms, status: 200
  end

  def show
    form = Form.find(params[:id])
    render json: form, status: 200
  end
end
