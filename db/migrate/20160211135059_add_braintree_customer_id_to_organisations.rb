class AddBraintreeCustomerIdToOrganisations < ActiveRecord::Migration
  def change
    add_column :organisations, :braintree_customer_id, :string
  end
end
