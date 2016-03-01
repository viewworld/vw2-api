class ReportDataValidator
  using HashExtensions

  def initialize(report)
    @report = report
    @report_data = @report.pure_data
    @form_data = @report.form.data
  end

  ERRORS = ["one or more 'id' fields are missing.",
            "one or more 'id' fields aren't numeric.",
            "'id' fields aren't unique.",
            "quantity doesnt match form.",
            "one or more fileds are of nonvalid type",
            "one or more text fields aren't in allowed length."]

  ALLOWED_TYPES = {string: ['text'],
                   array: ['gps'],
                   fixnum: ['media', 'numeric'] }

  def validate
    @report.errors[:base] << ERRORS[0] unless all_fields_contains_id?
    @report.errors[:base] << ERRORS[1] unless all_id_fields_are_numeric?
    @report.errors[:base] << ERRORS[2] unless all_id_fields_are_unique?
    @report.errors[:base] << ERRORS[3] unless quantity_match_form?
    @report.errors[:base] << ERRORS[4] unless all_fields_are_of_allowed_type?
    @report.errors[:base] << ERRORS[5] unless text_fields_in_range?
  end

  def all_fields_contains_id?
    @report_data.select { |field| field.keys.first.nil? }.empty?
  end

  def all_id_fields_are_numeric?
    @report_data.select do |field|
      key = field.keys.first
      key.to_i.to_s != key
    end.empty?
  end

  def all_id_fields_are_unique?
    ids = @report_data.map { |report_field| report_field.report_id }
    return true if ids == ids.uniq
  end

  def quantity_match_form?
    @form_data.size == @report_data.size
  end

  def all_fields_are_of_allowed_type?
    false_table = @report_data.map do |report_field|
      form_field = select_form_field report_field.report_id
      report_value_type = report_field.report_value_type
      false unless ALLOWED_TYPES[report_value_type].include? form_field[:type]
    end
    true unless false_table.include? false
  end

  def text_fields_in_range?
    false_table = text_reports.map do |report_field|
      form_field = select_form_field report_field.report_id
      length = form_field[:length]
      allowed_range = Range.new(length.first, length.last)
      false unless allowed_range.include? report_field.report_value.length
    end
    true unless false_table.include? false
  end

  private

  def select_form_field(id)
    @form_data.select do |form_field|
      form_field[:id] == id
    end.first
  end

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
