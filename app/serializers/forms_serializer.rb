class FormsSerializer < ActiveModel::Serializer
  attributes :id, :name, :data

  def data
    object.basic_data
  end
end

