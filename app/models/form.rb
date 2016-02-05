class Form < ActiveRecord::Base
  acts_as_paranoid
  before_save :check_or_update_order
  belongs_to :organisation
  has_many :reports

  validate do |form|
    FormDataValidator.new(form).validate
  end

  # Reads order column and returns it with each element as integer.
  def order
    stringified_order = read_attribute(:order)
    return [] if stringified_order.nil? || stringified_order.empty?

    stringified_order.map(&:to_i)
  end

  def groups
    str_groups = read_attribute(:groups)
    return [] if str_groups.nil? || str_groups.empty?

    int_groups = str_groups.map(&:to_i)
  end

  # Reads data column, sorts it according to corresponding order column.
  # Also calls with_indifferent_acces on each member of array, so its
  # possible to call any key as symbol, eg. data[0][:id] # => 1
  def data
    unordered = read_attribute(:data)
    return [] if unordered.nil? || unordered.empty?

    unordered = unordered.map { |item| item.with_indifferent_access }
    return unordered unless unordered.size == order.size

    ordered = unordered.sort_by { |item| order.index(item[:id]) }
    ordered
  end

  # Checks if order field and ids in data field match.
  # Returns true if so.
  # Fills order with ids from data field if not.
  def check_or_update_order
    ids = self.data.map { |item| item[:id] }
    return true if ids.sort == order.sort

    self.order = ids
  end
end

