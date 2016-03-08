class ReportSerializer < ActiveModel::Serializer
  include NullAttributesRemover
  attributes :id, :form_id, :metadata, :data

  def metadata
    {
      "created_at" => object.created_at,
      "user_id" => object.try(:user_id)
    }
  end
end
