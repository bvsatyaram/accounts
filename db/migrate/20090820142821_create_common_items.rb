class CreateCommonItems < ActiveRecord::Migration
  def self.up
    create_table :common_items do |t|
      t.integer :user_id, :null => false
      t.integer :group_id
      t.string :name
      t.string :description
      
      t.timestamps
    end
  end

  def self.down
    drop_table :common_items
  end
end
