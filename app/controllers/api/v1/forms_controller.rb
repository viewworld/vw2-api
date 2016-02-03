class Api::V1::FormsController < ApplicationController
  wrap_parameters format: :json

  # GET /forms
  def index
    forms = Form.all
    render json: forms, status: 200
  end

  # GET /forms/:id
  def show
    form = Form.find(params[:id])
    render json: form, status: 200
  end

  # POST /forms
  def create
    form = Form.create(form_params)
    if form.save
      render json: form, status: 201
    else
      render json: { errors: 'create error'}, status: 422
    end
  end

  # PATCH /forms/:id
  def update
    form = Form.find(params[:id])
    if form.update(form_params)
      render json: form, status: 200
    else
      render json: { errors: form.errors }, status: 422
    end
  end

  # DELETE /forms/:id
  def destroy
  end

  private

  def form_params
    params.require(:form).permit(:name,
                                 :active,
                                 :verification,
                                 order: [],
                                 groups: []).tap do |whitelisted|
      data = params[:form][:data]
      whitelisted[:data] = data if data
    end
  end
end
