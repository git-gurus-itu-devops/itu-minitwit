class Message < ActiveRecord::Base
  self.table_name = 'message'
  belongs_to :author, class_name: 'User'

  validates_presence_of :text
end
