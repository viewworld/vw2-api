class ReportDataValidator
  def initialize(report)
    @report = report
    @report_data = @report.pure_data
    @form_data = @report.form.data
  end

  def validate
    @report.errors[:base] << 'no id' unless all_fields_contains_id?
    @report.errors[:base] << 'nonum id' unless all_id_fields_are_numeric? 
    @report.errors[:base] << 'nonuniq id' unless all_id_fields_are_unique? 
    @report.errors[:base] << 'quantity doesnt match' unless quantity_match_form? 
    @report.errors[:base] << 'nonvalid type' unless all_fields_are_of_allowed_type?
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
      false unless form_field && form_field[:type] == ALLOWED_TYPES[report_value_type]
    end
    return true unless truth_table.include?(false)
  end

  ALLOWED_TYPES = { string: 'text' }
end
