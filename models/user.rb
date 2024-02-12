class User < ActiveRecord::Base
  self.table_name = "user"

  has_and_belongs_to_many :followers,
    class_name: "User",
    join_table: "follower",
    foreign_key: "whom_id",
    association_foreign_key: "who_id",
    inverse_of: :following

  has_and_belongs_to_many :following,
    class_name: "User",
    join_table: "follower",
    foreign_key: "who_id",
    association_foreign_key: "whom_id",
    inverse_of: :followers

  has_many :messages, foreign_key: :author_id

  has_secure_password
end
