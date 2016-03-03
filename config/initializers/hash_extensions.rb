module Refinements
  def report_id
    keys.first.to_i
  end

  def report_value
    values.first
  end

  def report_value_type
    values.first.class.name.underscore.to_sym
  end

  %w(media text select).each do |type|
    define_method "form_#{type}?" do
      self[:type] == type
    end
  end

  def form_required?
    self[:required] == true
  end
end

module HashExtensions
  refine Hash do
    include ::Refinements
  end
end

class HashWithIndifferentAccess
  include ::Refinements
end
