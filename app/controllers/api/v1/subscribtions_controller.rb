class Api::V1::SubscribtionsController < ApplicationController
  before_action :authenticate_with_token!
  before_action :permit_admin!

  def show
  end

  def create
    customer = Braintree::Customer.create(first_name: params[:first_name],
                                          last_name: params[:last_name],
                                          company: params[:company],
                                          email: current_user.email,
                                          phone: params[:phone])
    payment_method = Braintree::PaymentMethod.create(customer_id: customer.customer.id,
                                                     payment_method_nonce: 'fake-valid-nonce')
    subscribtion = Braintree::Subscription.create(payment_method_token: payment_method.payment_method.token,
                                                  plan_id: 'vw2_main')
    if subscribtion.success?
      current_user.update(braintree_customer_id: customer.customer.id) unless current_user.has_payment_info?
      head 201
    else
      render json: { errors: subscribtion.errors }, status: 422
    end
  end

  def destroy
  end

  private

  def permit_admin!
    unless current_user.admin?
      render json: { errors: 'only admin allowed' }, status: 422
    end
  end

  def generate_client_token
    if current_user.has_payment_info?
      Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id)
    else
      Braintree::ClientToken.generate
    end
  end
end
