require 'digest'

class User < ActiveRecord::Base
  self.table_name = 'user'

  has_and_belongs_to_many :followers,
                          class_name: 'User',
                          join_table: 'follower',
                          foreign_key: 'whom_id',
                          association_foreign_key: 'who_id',
                          inverse_of: :following

  has_and_belongs_to_many :following,
                          class_name: 'User',
                          join_table: 'follower',
                          foreign_key: 'who_id',
                          association_foreign_key: 'whom_id',
                          inverse_of: :followers

  has_many :messages, foreign_key: :author_id

  has_secure_password

  def follows?(other_user)
    following.include?(other_user)
  end

  def gravatar(size = 80)
    md5 = Digest::MD5.new
    md5 << email.strip.downcase.encode('utf-8')
    md5_hash = md5.hexdigest
    "http://www.gravatar.com/avatar/#{md5_hash}?d=identicon&s=#{size}"
  end
end
