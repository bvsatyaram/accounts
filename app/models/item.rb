class Item < ActiveRecord::Base
  belongs_to :user
  belongs_to :common_item
  validates_presence_of :name, :user

  after_create :increment_balance
  after_destroy :decrement_balance

  def self.create_items(users, common_item)
    default_amount = (common_item.cost.to_f/users.size.to_f).round
    users.each do |user|
      @item = user.items.create(:default_amount => default_amount, :common_item => common_item, :name => common_item.name)
    end
  end

  private
  def increment_balance
    self.user.update_attribute(:balance, self.user.balance + self.default_amount)
  end

  def decrement_balance
    self.user.update_attribute(:balance, self.user.balance - self.default_amount)
  end
end
