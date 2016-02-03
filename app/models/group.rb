class Group < ActiveRecord::Base
  extend ActsAsTree::TreeView
  acts_as_tree order: 'name'
  belongs_to :organisation
  has_many :users
end
