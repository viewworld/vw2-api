class Organisation < ActiveRecord::Base
  has_many :groups
  has_many :users, through: :groups
  has_many :forms

  def has_payment_info?
    braintree_customer_id
  end
end
