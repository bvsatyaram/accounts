class Item < ActiveRecord::Base
  belongs_to :user
  belongs_to :common_item
  validates_presence_of :name, :user, :transaction_date

  before_validation_on_create :add_transaction_date
  after_create :increment_balance
  after_destroy :decrement_balance

  def group_user
    self.common_item.group.get_group_user(self.user) if self.common_item && self.common_item.group_user
  end

  private
  
  def increment_balance
    self.user.update_attribute(:net_balance, self.user.net_balance + self.default_amount)
    self.group_user.update_attribute(:balance, self.group_user.balance + self.default_amount)
  end

  def decrement_balance
    self.user.update_attribute(:net_balance, self.user.net_balance - self.default_amount)
    self.group_user.update_attribute(:balance, self.group_user.balance - self.default_amount) if self.group_user
  end

  def add_transaction_date
    if self.common_item
      self.transaction_date = self.common_item.transaction_date
    end
  end
end
