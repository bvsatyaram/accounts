class CommonItem < ActiveRecord::Base
  has_many :items, :dependent => :destroy
  belongs_to :group_user

  validates_presence_of :cost, :name, :group_user
  validates_numericality_of :cost
  
  after_create :decrement_user_balance
  after_destroy :increment_user_balance

  def self.per_page
    50
  end

  def user
    self.group_user.user
  end

  def group
    self.group_user.group
  end

  private
  
  def decrement_user_balance
    self.user.update_attribute(:net_balance, self.user.net_balance - self.cost)
    self.group_user.update_attribute(:balance, self.group_user.balance - self.cost)
  end

  def increment_user_balance
    if self.group_user
      self.user.update_attribute(:net_balance, self.user.net_balance + self.cost)
      self.group_user.update_attribute(:balance, self.group_user.balance + self.cost)
    end  
  end

end
