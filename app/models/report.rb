class Report < ActiveRecord::Base
  belongs_to :form
  has_many :texts
  serialize :data, ArraySerializer

  # Returns associated Form filled with Report's data values.
  # Each report field in Form's data JSON is filled with particular
  # Report's data value (if present).
  def data
    report_data = read_attribute(:data)
    filled_data = self.form.data
    filled_data.each do |form_item|
      report_value = report_data.select do |report_item|
        report_item.keys.first == form_item[:id]
      end

      if report_value.nil? || report_value.empty?
        report_value
      else
        report_value = report_value.first.values.first
      end
      form_item[:items][:report] = report_value
    end
    ordered(filled_data)
  end

  def ordered(collection)
    form_order = self.form.order
    return collection if collection.nil? ||
                         collection.empty? ||
                         form_order.nil? ||
                         form_order.empty?

    ids = []
    collection.each { |item| ids << item.keys.first }
    real_order = form_order & ids
    collection.sort_by do |item|
      real_order.index(item.keys.first)
    end
  end
end
