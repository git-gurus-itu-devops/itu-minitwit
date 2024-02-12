class AddPasswordDigestToUser < ActiveRecord::Migration[7.1]
  def change
    rename_column :user, :pw_hash, :password_legacy
    change_column :user, :password_legacy, :string, null: true
    add_column :user, :password_digest, :string
  end
end
