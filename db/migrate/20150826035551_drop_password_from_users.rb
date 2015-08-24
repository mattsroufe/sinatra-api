class DropPasswordFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :password_digest
  end
end

      user.name        = jwt['name']
      user.given_name  = jwt['given_name']
      user.family_name = jwt['family_name']
