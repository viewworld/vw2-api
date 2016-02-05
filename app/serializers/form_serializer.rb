class FormSerializer < ActiveModel::Serializer
  include NullAttributesRemover
  attributes :id,
             :name,
             :active,
             :locked,
             :verification,
             :data,
             :groups

  def verification
    {
      "required" => object.verification_required,
      "default" => object.verification_default
    }
  end

  def groups
    availible_groups = object.organisation.groups
    availible_groups.each do |availible_group|
      availible_group.associated = true if object.groups.include?(availible_group.id)
    end
    ActiveModel::ArraySerializer.new(availible_groups, each_serializer: GroupSerializer)
  end
end

