class ReportDataValidator
  using HashExtensions

  def initialize(report)
    @report = report
    @report_data = @report.pure_data
    @form = @report.form
    @form_data = @form.data
  end

  ERRORS = { missing_ids: "one or more 'id' fields are missing.",
             non_num_ids: "one or more 'id' fields aren't numeric.",
             non_uniq_ids: "'id' fields aren't unique.",
             non_match_type: "one or more fields doesn't match form's field type.",
             non_present_req:"one or more required fields aren't present.",
             non_exist_media: "one ore more 'media' fields doesn't exist on server." }.freeze

  ALLOWED_TYPES = {string: ['text', 'barcode', 'date_time'],
                   array: ['gps', 'select'],
                   fixnum: ['media', 'numeric']}.freeze

  def validate
    @report.errors[:base] << ERRORS[:missing_ids] unless fields_contains_id?
    @report.errors[:base] << ERRORS[:non_num_ids] unless id_fields_are_numeric?
    @report.errors[:base] << ERRORS[:non_uniq_ids] unless id_fields_are_unique?
    @report.errors[:base] << ERRORS[:non_match_type] unless fields_are_of_allowed_type?
    @report.errors[:base] << ERRORS[:non_present_req] unless required_fields_are_present?
    @report.errors[:base] << ERRORS[:non_exist_media] unless media_fields_exists?
  end

  def fields_contains_id?
    @report_data.select { |field| field.keys.first.nil? }.empty?
  end

  def id_fields_are_numeric?
    @report_data.select do |field|
      key = field.keys.first
      key.to_i.to_s != key
    end.empty?
  end

  def id_fields_are_unique?
    ids = @report_data.map { |report_field| report_field.report_id }
    return true if ids == ids.uniq
  end

  def quantity_match_form?
    @form_data.size == @report_data.size
  end

  def fields_are_of_allowed_type?
    false_table = @report_data.map do |report_field|
      form_field = @form.field report_field.report_id
      report_value_type = report_field.report_value_type
      false unless ALLOWED_TYPES[report_value_type].include? form_field[:type]
    end
    true unless false_table.include? false
  end

  def text_fields_in_range?
    false_table = text_reports.map do |report_field|
      form_field = @form.field report_field.report_id
      length = form_field[:length]
      allowed_range = Range.new(length.first, length.last)
      false unless allowed_range.include? report_field.report_value.length
    end
    true unless false_table.include? false
  end

  def media_fields_exists?
    ids = @report.media_ids
    exuals = ReportFile.where(id: ids).size == ids.size
    exuals ? true : false
  end

  def required_fields_are_present?
    @form.required_ids.sort == @report.data_ids.sort
  end

  private

  # Returns array of only textual report fields.
  def text_reports
    form_text_ids = @form_data.select do |field|
      field[:type] == 'text'
    end.map { |field| field['id'] }

    @report_data.select do |report_field|
      form_text_ids.include? report_field.report_id
    end
  end
end
