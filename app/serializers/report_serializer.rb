class ReportSerializer < ActiveModel::Serializer
  attributes :id, :form_id, :data
#  def data
#    new = object.data.map do |k, v|
#      v.merge(object.form.data[k])
#    end
#  end
end
