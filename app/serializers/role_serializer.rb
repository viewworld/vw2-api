class RoleSerializer < ActiveModel::Serializer
  attributes :name, :data
  belongs_to :user
end
