class ReportDataValidator
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
    ids = @report_data.map { |field| field.keys.first }
    return true if ids == ids.uniq
  end

  def quantity_match_form?
    @form_data.size == @report_data.size
  end

  def all_fields_are_of_allowed_type?
    truth_table = @report_data.map do |field|
      form_field = @form_data.select do |ffield|
        ffield[:id] == field.keys.first.to_i
      end.first
      report_value_type = field.values.first.class.name.underscore.to_sym
      false unless ALLOWED_TYPES[report_value_type].include? form_field[:type]
    end
    return true unless truth_table.include? false
  end

  def text_fields_in_range?
    fields = text_reports
    truth_table = fields.map do |field|
      form_field = @form_data.select do |ffield|
        ffield[:id] == field.keys.first.to_i
      end.first
      allowed_range = Range.new(form_field[:length].first, form_field[:length].last)
      false unless allowed_range.include? field.values.first.length
    end
    return true unless truth_table.include? false
  end

  private

  # Returns array of only textual report fields.
  def text_reports
    form_text_ids = @form_data.select do |field|
      field[:type] == 'text'
    end.map { |field| field['id'] }

    @report_data.select do |field|
      form_text_ids.include? field.keys.first.to_i
    end
  end
end
