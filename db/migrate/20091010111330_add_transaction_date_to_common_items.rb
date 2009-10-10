class AddTransactionDateToCommonItems < ActiveRecord::Migration
  def self.up
    change_table :common_items do |t|
      t.date :transaction_date
    end

    CommonItem.all.each do |c_item|
      c_item.update_attribute(:transaction_date, c_item.created_at)
    end
    
  end

  def self.down
    change_table :common_items do |t|
      t.remove :transaction_date
    end
  end
end
