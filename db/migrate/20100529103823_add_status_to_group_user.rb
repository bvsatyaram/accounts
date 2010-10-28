class AddStatusToGroupUser < ActiveRecord::Migration
  def self.up
    add_column :group_users, :status, :integer, :default => GroupUser::Status::ACTIVE
  end

  def self.down
    remove_column :group_users, :status
  end
end
