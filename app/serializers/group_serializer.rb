class GroupSerializer < ActiveModel::Serializer
  include NullAttributesRemover

  attributes :id, :parent_id, :name, :associated
end
