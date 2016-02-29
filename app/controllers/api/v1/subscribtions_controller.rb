class Api::V1::SubscribtionsController < ApplicationController
  before_action :authenticate_with_token!
  before_action :permit_admin!
  before_action :find_customer

  def show
    if @customer
      render json: @customer, status: 200
    else
      render json: { error: 'doesnt exist' }
    end
  end

  def create
    if current_user.has_payment_info?
      render json: { errors: 'customer exists.' }
    else
      customer = Braintree::Customer.create(first_name: params[:first_name],
                                            last_name: params[:last_name],
                                            company: params[:company],
                                            email: current_user.email,
                                            phone: params[:phone])

      if customer.success?
        current_user.organisation.
          update(braintree_customer_id: customer.customer.id)
        render json: { ok: 'customer created.' }
      else
        render json: { errors: subscribtion.errors }, status: 422
      end
    end
  end

  def destroy
    customer = Braintree::Customer.delete(@customer.id)
    if customer.success?
      head 200
    else
      render json: { errors: customer.errors }
    end
  end

  private

  def find_customer
    @customer = BraintreeRails::Customer.find(current_user.has_payment_info?)
  end

  def permit_admin!
    unless current_user.admin?
      render json: { errors: 'only admin allowed' }, status: 422
    end
  end

  def generate_client_token
    if current_user.organisation.has_payment_info?
      Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id)
    else
      Braintree::ClientToken.generate
    end
  end
end
