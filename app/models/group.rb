class Group < ActiveRecord::Base
  attr_accessor :associated
  extend ActsAsTree::TreeView
  acts_as_tree order: 'name'
  belongs_to :organisation
  has_many :users
  default_scope { order('parent_id ASC') }
end
