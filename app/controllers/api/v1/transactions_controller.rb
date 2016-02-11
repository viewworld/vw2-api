class Api::V1::TransactionsController < ApplicationController
  before_action :authenticate_with_token!

  def create
    unless current_user.has_payment_info?
      result = Braintree::Transaction.sale(
        amount: '10.0',
        payment_method_nonce: 'fake-valid-nonce',
        customer: {
          first_name: params[:first_name],
          last_name: params[:last_name],
          company: params[:company],
          email: current_user.email,
          phone: params[:phone]
        },
        options: {
          store_in_vault: true
        })
    else
      result = Braintree::Transaction.sale(amount: '10.0',
                                           payment_method_nonce: 'fake-valid-nonce')
    end

    if result.success?
      head 201
    else
      render json: { errors: result.errors }
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
