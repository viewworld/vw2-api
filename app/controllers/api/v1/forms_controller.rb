class Api::V1::FormsController < ApplicationController
  # respond_to :json

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

  def update
    form = Form.find(params[:id])
    if form.update(form_params)
      render json: form, status: 200
    else
      render json: { errors: form.errors }, status: 422
    end
  end

  private

  def form_params
    params.require(:form).permit(:name,
                                 :active,
                                 :verification,
                                 groups: []).tap do |whitelisted|
      whitelisted[:data] = params[:form][:data]
    end
  end
end
