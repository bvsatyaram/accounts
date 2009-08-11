class CreateGroupUsers < ActiveRecord::Migration
  def self.up
    create_table :group_users do |t|
      t.integer :user_id
      t.integer :group_id
      t.float :balance, :default => 0.0

      t.timestamps
    end

    add_index :group_users, :user_id
    add_index :group_users, :group_id
  end

  def self.down
    drop_table :group_users
  end
end
