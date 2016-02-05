class Api::V1::FormsController < ApplicationController
  before_action :authenticate_with_token!
  load_and_authorize_resource

  # GET /forms
  def index
    render json: @forms, status: 200
  end

  # GET /forms/:id
  def show
    render json: @form, status: 200
  end

  # POST /forms
  def create
    if @form.save
      render json: @form, status: 201
    else
      render json: { errors: @form.errors }, status: 422
    end
  end

  # PATCH /forms/:id
  def update
    if @form.update_attributes(form_params)
      render json: @form, status: 200
    else
      render json: { errors: @form.errors }, status: 422
    end
  end

  # DELETE /forms/:id
  def destroy
    if @form.destroy
      head 204
    else
      render json: { errors: 'Cannot destroy this form.' }, status: 422
    end
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
