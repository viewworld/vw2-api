class FormSerializer < ActiveModel::Serializer
  attributes :id, :order, :data

#  def data
#    input = object.data.dup
#    input.delete('order')
#    output = input.sort_by { |key, value| order.index(key) }
#    output = output.to_h
#  end
end
