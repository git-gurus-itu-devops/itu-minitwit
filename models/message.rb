class Message < ActiveRecord::Base
  self.table_name = 'message'
  belongs_to :author, class_name: 'User'

  scope :authored_by, ->(users) { where(author: users) }

  validates_presence_of :text
end
