class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string  :name
      t.integer :common_item_id
      t.integer :user_id, :null => false
      t.integer :default_amount, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
