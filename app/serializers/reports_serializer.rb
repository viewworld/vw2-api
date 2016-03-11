class ReportsSerializer < ActiveModel::Serializer
  attributes :id, :name, :reports

  def reports
    object.reports.size
  end
end
