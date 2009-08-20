class CreateCommonItems < ActiveRecord::Migration
  def self.up
    create_table :common_items do |t|
      t.integer :group_user_id
      t.string :name
      t.string :description
      t.integer :cost, :default => 0
      
      t.timestamps
    end
  end

  def self.down
    drop_table :common_items
  end
end
