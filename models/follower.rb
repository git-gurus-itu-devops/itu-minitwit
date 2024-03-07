class Follower < ActiveRecord::Base
  belongs_to :who, class_name: "User"
  belongs_to :whom, class_name: "User"
end
