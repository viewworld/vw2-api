class Report < ActiveRecord::Base
  belongs_to :form
  has_many :texts
  #serialize :data, HashSerializer
end
