class Form < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :user
  before_save :check_or_update_order
  belongs_to :organisation
  has_many :reports, dependent: :destroy

  after_create :create_log

  validate do |form|
    FormDataValidator.new(form).validate
  end

  def create_log
    Log.create(
      user: user,
      subject: self,
      activity: "Added new form '#{name}'")
  end

  %w(media text select required).each do |type|
    define_method "#{type}_data" do
      data.select { |f| f.send("form_#{type}?") }
    end

    define_method "#{type}_ids" do
      send("#{type}_data").map(&:id)
    end
  end

  def field(id)
    data.find { |form_field| form_field.id == id }
  end

  # Reads array columns and returns it with each element as an integer.
  %w(order groups).each do |collection|
    define_method collection do
      stringified = read_attribute collection
      return [] if stringified.nil? || stringified.empty?

      stringified.map(&:to_i)
    end
  end

  # Reads data column, sorts it according to corresponding order column.
  # Also calls with_indifferent_acces on each member of array, so its
  # possible to call any key as symbol, eg. data[0][:id] # => 1
  def data
    unordered = read_attribute(:data)
    return [] if unordered.nil? || unordered.empty?

    unordered = unordered.map(&:with_indifferent_access)
    return unordered unless unordered.size == order.size

    unordered.sort_by { |item| order.index(item[:id]) }
  end

  # Checks if order field and ids in data field match.
  # Returns true if so.
  # Fills order with ids from data field if not.
  def check_or_update_order
    ids = data.map { |item| item[:id] }
    return true if ids.sort == order.sort

    self.order = ids
  end

  # Lists only id and title from each data item.
  def basic_data
    unordered = data.map { |item| item.slice(:id, :title, :type) }
   # unordered.sort_by { |item| order.index(item[:id]) }
  end
end
