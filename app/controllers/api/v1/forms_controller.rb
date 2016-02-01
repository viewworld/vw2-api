class Api::V1::FormsController < ApplicationController
  def index
    forms = Form.all
    render json: forms, status: 200
  end

  def show
    form = Form.find(params[:id])
    render json: form, status: 200
  end

  def create
    form = Form.create(form_params)
    if form.save
      render json: form, status: 201
    else
      render json: { errors: 'create error'}, status: 422
    end
  end

  private

  def form_params
    params.permit(:name, :data)
  end
end
