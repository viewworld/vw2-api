class ReportFileSerializer < ActiveModel::Serializer
  attributes :id, :file_name, :url

  def file_name
    object.file_file_name
  end

  def url
    object.file.url
  end
end
