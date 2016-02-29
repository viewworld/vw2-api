class Api::V1::PaymentMethodsController < ApplicationController
  before_action :authenticate_with_token!
  before_action :find_customer
  before_action :find_payment_method, except: :create

  def show
  end

  def create
    payment_method = Braintree::PaymentMethod.
      create(customer_id: @customer.id,
             payment_method_nonce: 'fake-valid-nonce')
    if payment_method
      head 201
    else
      render json: { errors: payment_method.errors }, status: 422
    end
  end

  def update
    payment_method = Braintree::PaymentMethod.
      update(@payment_method.token,
             options: { make_default: params[:default] })
    if payment_method.success?
      head 200
    else
      render json: { errors: payment_method.errors }, status: 422
    end
  end

  def destroy
    payment_method = Braintree::PaymentMethod.
      delete(@payment_method.token)
    if payment_method.success?
      head 200
    else
      render json: { errors: payment_method.errors }
    end
  end

  private

  def find_customer
    @customer = Braintree::Customer.find(current_user.has_payment_info?)
  end

  def find_payment_method
    id = params[:id].to_i + 1
    @payment_method = @customer.payment_methods[id]

    if @payment_method
      @payment_method
    else
      render json: { errors: 'no payment method' }
    end
  end

  def payment_method_params
    params.permit(:token, :default)
  end
end
