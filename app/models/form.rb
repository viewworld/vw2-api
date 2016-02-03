class Form < ActiveRecord::Base
  # serialize :data, HashSerializer
  # store_accessor :data, :test
  has_many :reports

  def order
    read_attribute(:order).map(&:to_i)
  end

  def data
    unordered = read_attribute(:data)
    unordered = unordered.map { |item| item.with_indifferent_access }
    ordered = unordered.sort_by { |item| order.index(item[:id]) }
    ordered
  end
end
