class CreateUsers < ActiveRecord::Migration[5.1]
  def up
    create_table :users
    add_column :users, :username, :string, unique: true

    add_index(:users, :username)
  end

  def down
    drop_table :users
  end
end
