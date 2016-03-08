class FormDataValidator < ActiveModel::Validator
  def initialize(form)
    @form = form
  end

  ERRORS = ["one or more 'id' fields are missing.",
            "one or more 'id' fields aren't numeric.",
            "'id' fields aren't unique.",
            "one or more 'type' fields aren't allowed.",
            "one or more 'required' fields are in wrong format.",
            "one or more 'hidden' fields are in wrong format.",
            "one ore more 'groups' fields doesn't match real group IDs."].freeze

  ALLOWED_TYPES = %w(text
                     media
                     select
                     numeric
                     date_time
                     upload
                     gps
                     page_break
                     branching
                     signature).freeze

  def validate
    @form.errors[:base] << ERRORS[0] unless fields_contains_id?
    @form.errors[:base] << ERRORS[1] unless id_fields_are_numeric?
    @form.errors[:base] << ERRORS[2] unless id_fields_are_unique?
    @form.errors[:base] << ERRORS[3] unless fields_are_of_allowed_type?
    @form.errors[:base] << ERRORS[4] unless fields_contains_required?
    @form.errors[:base] << ERRORS[5] unless fields_contains_hidden?
    @form.errors[:base] << ERRORS[6] unless group_fields_match_real_groups?
  end

  def fields_contains_id?
    @form.data.select { |field| field[:id].nil? }.empty?
  end

  def id_fields_are_numeric?
    @form.data.select { |field| !field[:id].is_a?(Fixnum) }.empty?
  end

  def id_fields_are_unique?
    ids = @form.data.map { |field| field[:id] }
    return true if ids == ids.uniq
  end

  def fields_are_of_allowed_type?
    @form.data.select { |field| !ALLOWED_TYPES.include?(field[:type]) }.empty?
  end

  def fields_contains_editable?
    @form.data.select { |field| !field[:editable].boolean? }.empty?
  end

  def fields_contains_required?
    @form.data.select { |field| !field[:required].boolean? }.empty?
  end

  def fields_contains_hidden?
    @form.data.select { |field| !field[:hidden].boolean? }.empty?
  end

  def group_fields_match_real_groups?
    group_ids = Organisation.find(@form.organisation_id).groups.map(&:id)
    form_group_ids = @form.groups
    (form_group_ids - group_ids).empty?
  end
end
