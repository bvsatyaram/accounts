class Item < ActiveRecord::Base
  belongs_to :user
  belongs_to :common_item
  validates_presence_of :name, :user

  after_create :increment_balance
  after_destroy :decrement_balance

  def self.create_items(user_ids, common_item)
    users = common_item.group.users.find_all_by_id(user_ids)
    default_amount = (common_item.cost.to_f/users.size.to_f).round
    users.each do |user|
      @item = user.items.create(:default_amount => default_amount, :common_item => common_item, :name => common_item.name)
    end
  end

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
end
