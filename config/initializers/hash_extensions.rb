module Refinements
  def method_missing(method, *args, &block)
    if self.has_key?(method)
      return self[method]
    else
      raise NoMethodError.
        new("undefined method '#{method}' for #{self.class}")
    end
  end

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

class Hash
  include ::Refinements
end

class HashWithIndifferentAccess
  include ::Refinements
end
