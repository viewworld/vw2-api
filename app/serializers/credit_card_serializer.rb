class CreditCardSerializer < ActiveModel::Serializer
  attributes :id,
             :default,
             :last_4,
             :expiration_date,
             :expiration_month,
             :expiration_year,
             :token,
             :image_url
end
