class User < ActiveRecord::Base
  self.table_name = "user"

  has_secure_password
end
