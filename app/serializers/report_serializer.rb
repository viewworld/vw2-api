class ReportSerializer < ActiveModel::Serializer
  include NullAttributesRemover
  attributes :id, :form_id, :data

  def form_data
    data = object.form.data.dup
    data.delete('order')
    data
  end
end
