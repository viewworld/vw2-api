class FormDataValidator < ActiveModel::Validator
  def initialize(form)
    @form = form
  end

  ERRORS = [ "one or more 'id' fields are missing.",
             "one or more 'id' fields aren't numeric.",
             "'id' fields aren't unique.",
             "one or more 'type' fields aren't allowed.",
             "one or more 'editable' fields are in wrong format.",
             "one or more 'required' fields are in wrong format." ]

  ALLOWED_TYPES = %w( text
                      media
                      select
                      numeric
                      date_time
                      yes_no
                      gps
                      metadata )

  def validate
    @form.errors[:base] << ERRORS[0] unless all_fields_contains_id?
    @form.errors[:base] << ERRORS[1] unless all_id_fields_are_numeric?
    @form.errors[:base] << ERRORS[2] unless all_id_fields_are_unique?
    @form.errors[:base] << ERRORS[3] unless all_fields_are_of_allowed_type?
    @form.errors[:base] << ERRORS[4] unless all_fields_contains_editable_boolean?
    @form.errors[:base] << ERRORS[5] unless all_fields_contains_required_boolean?
  end

  def all_fields_contains_id?
    @form.data.select { |field| field[:id].nil? }.empty?
  end

  def all_id_fields_are_numeric?
    @form.data.select { |field| !field[:id].is_a?(Fixnum) }.empty?
  end

  def all_id_fields_are_unique?
    ids = @form.data.map { |field| field[:id] }
    return true if ids == ids.uniq
  end

  def all_fields_are_of_allowed_type?
    @form.data.select { |field| !ALLOWED_TYPES.include?(field[:type]) }.empty?
  end

  def all_fields_contains_editable_boolean?
    @form.data.select { |field| !field[:editable].boolean? }.empty?
  end

  def all_fields_contains_required_boolean?
    @form.data.select { |field| !field[:required].boolean? }.empty?
  end
end
