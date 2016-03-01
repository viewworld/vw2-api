class Report < ActiveRecord::Base
  using HashExtensions

  belongs_to :form
  delegate :organisation, to: :form, allow_nil: true

  validate do |report|
    ReportDataValidator.new(report).validate
  end

  def pure_data
    read_attribute(:data)
  end

  # Returns associated Form filled with Report's data values.
  # Each report field in Form's data JSON is filled with particular
  # Report's data value (if present).
  def data
    filled_data = self.form.data
    filled_data.each do |form_item|
      report = select_report form_item[:id]
      if report.nil?
        report
      elsif form_item.form_media?
        report = serialized_report_file(report.report_value)
      else
        report = report.report_value
      end
      form_item[:items][:value] = report
    end
    ordered(filled_data)
  end

  def ordered(collection)
    form_order = self.form.order
    return collection if collection.nil? ||
                         collection.empty? ||
                         form_order.nil? ||
                         form_order.empty?

    ids = []
    collection.each { |item| ids << item.keys.first }
    real_order = form_order & ids
    collection.sort_by do |item|
      real_order.index(item.keys.first)
    end
  end

  def serialized_report_file(id)
    report_file = ReportFile.find_by_id(id)
    serialized = { name: report_file.file_file_name,
                   content_type: report_file.file_content_type,
                   url: report_file.file.url }
    return serialized
  end

  def select_report(id)
    pure_data.select do |report_item|
      report_item.report_id == id
    end.first
  end
end
