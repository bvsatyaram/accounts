class AddTransactionTypeToCommonItem < ActiveRecord::Migration
  def self.up
    change_table :common_items do |t|
      t.integer :transaction_type, :default => 0
    end
  end

  def self.down
    change_table :common_items do |t|
      t.remove :transaction_type
    end
  end
end