class Message < ActiveRecord::Base
  self.table_name = "message"

  validates_presence_of :text
end
