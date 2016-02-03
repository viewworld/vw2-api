class Organisation < ActiveRecord::Base
  has_many :groups
  has_many :users, through: :groups
  has_many :forms
end
