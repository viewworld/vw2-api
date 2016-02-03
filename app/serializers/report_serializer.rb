class ReportSerializer < ActiveModel::Serializer
  attributes :id, :form_id, :data

  def form_data
    data = object.form.data.dup
    data.delete('order')
    data
  end

  def data
    form_data.each do |point, payload|
      payload[:items][:report] = object.data[point]
    end
  end
end
