class Report < ActiveRecord::Base
  enum status: ['verified', 'submitted']
  belongs_to :user
  belongs_to :form
  delegate :organisation, to: :form, allow_nil: true

  after_create :create_log

  validate do |report|
    ReportDataValidator.new(report).validate
  end

  def create_log
    log = { user: user,
            subject: self,
            activity: "Added new observation '#{form.name}'" }

    CreateLogJob.perform_later log
  end

  def data_ids
    pure_data.map(&:report_id)
  end

  def pure_data
    read_attribute(:data)
  end

  def media_ids
    form_ids = form.media_ids
    pure_data.select do |report_field|
      form_ids.include? report_field.report_id
    end.map { |media_field| media_field.report_id }
  end

  def select_data(required_only = false)
    form.select_ids.map do |id|
      if required_only
        required?(id)
      else
        field(id)
      end
    end.compact
  end

  # Returns associated Form filled with Report's data values.
  # Each report field in Form's data JSON is filled with particular
  # Report's data value (if present).
  def data
    filled_data = self.form.data
    filled_data.each do |form_item|
      report = field form_item.id
      if report.nil?
        report
      elsif form_item.form_media?
        report = serialized_report_file(report['assetId'])
      else
        report = report.report_value
      end
      form_item[:value] = report
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
    if report_file = ReportFile.find_by_id(id)
      { name: report_file.file_file_name,
        content_type: report_file.file_content_type,
        url: report_file.file.url }
    else
      nil
    end
  end

  def field(id)
    pure_data.find do |report_field|
      report_field.report_id == id
    end
  end

  def required?(id)
    form.field(id).required ? field(id) : nil
  end
end
