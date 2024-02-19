class Message < ActiveRecord::Base
  self.table_name = 'message'
  belongs_to :author, class_name: 'User'

  scope :unflagged, -> { where(flagged: 0) }

  scope :authored_by, ->(users) { where(author: users) }

  validates_presence_of :text

  def sim_format
    {
      content: text,
      user: author.username,
      pub_date: pub_date
    }
  end
end
