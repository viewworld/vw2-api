class Form < ActiveRecord::Base
  # serialize :data, HashSerializer
  # store_accessor :data, :test
  before_save :check_or_update_order
  belongs_to :organisation
  has_many :reports

  # Reads order column and returns it with each element as integer.
  def order
    read_attribute(:order).map(&:to_i)
  end

  # Reads data column, sorts it according to corresponding order column.
  # Also calls with_indifferent_acces on each member of array, so its
  # possible to call any key as symbol, eg. data[0][:id] # => 1
  def data
    unordered = read_attribute(:data)
    unordered = unordered.map { |item| item.with_indifferent_access }
    ordered = unordered.sort_by { |item| order.index(item[:id]) }
    ordered
  end

  def check_or_update_order
    ids = []
    self.data.each do |item|
      ids << item[:id]
    end

    return true if ids.sort == order.sort

    self.order = ids
  end
end

