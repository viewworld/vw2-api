class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :phone

  has_many :credit_cards
end
