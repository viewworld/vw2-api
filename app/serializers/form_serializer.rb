class FormSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :order,
             :active,
             :locked,
             :verification,
             :groups,
             :data

  def verification
    {
      "required" => object.verification_required,
      "default" => object.verification_default
    }
  end
end
