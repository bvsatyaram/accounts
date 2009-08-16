class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.integer :user_id
      t.string :name
      t.text :description
      t.string :code

      t.timestamps
      
      t.column :created_at, :datetime
      t.column :redeemed_at, :datetime
      t.column :redeemed_by_id, :integer

      t.column :expires_on, :datetime
    end
  end

  def self.down
    drop_table :groups
  end
end
