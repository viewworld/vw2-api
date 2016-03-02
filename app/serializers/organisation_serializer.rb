class OrganisationSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :groups
  has_many :users
end
