class AddTransactionDateToItem < ActiveRecord::Migration
  def self.up
    change_table :items do |t|
      t.date :transaction_date
    end

    Item.all.each do |item|
      item.update_attribute(:transaction_date, item.common_item.transaction_date)
    end
  end

  def self.down
    change_table :items do |t|
      t.remove :transaction_date
    end
  end
end
