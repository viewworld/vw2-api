class FormsSerializer < ActiveModel::Serializer
  attributes :id, :name, :data

  def data
    object.simple_data
  end
end

