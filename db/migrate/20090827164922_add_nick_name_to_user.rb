class AddNickNameToUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :nick_name
      t.boolean :app_admin, :default => false
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :nick_name
      t.remove :app_admin
    end
  end
end
