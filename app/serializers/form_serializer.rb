class FormSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
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
