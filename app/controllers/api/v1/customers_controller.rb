class Api::V1::CustomersController < ApplicationController
  before_action :authenticate_with_token!
  before_action :find_customer

  def show
    if @customer
      render json: @customer, status: 200
    else
      render json: { error: 'doesnt exist' }, status: 422
    end
  end

  def create
    if current_user.has_payment_info?
      render json: { error: 'customer exists' }
    else
      customer = Braintree::Customer.create(first_name: params[:first_name],
                                            last_name: params[:last_name],
                                            company: params[:company],
                                            email: current_user.email,
                                            phone: params[:phone])
      if customer
        current_user.organisation.update(braintree_customer_id: customer.customer.id)
        head 201
      else
        render json: { errors: customer.errors }, status: 422 unless customer
      end
    end
  end

  private

  def find_customer
    @customer = BraintreeRails::Customer.find(current_user.has_payment_info?)
  end
end
