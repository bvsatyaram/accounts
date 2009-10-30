class CommonItem < ActiveRecord::Base
  class Type
    SHARED_EQUALLY = 0
    SHARED_UNEQUALLY = 1
    PAYMENT = 2
    RECORD_PAYMENT = 3

    def self.all
      [SHARED_UNEQUALLY, SHARED_EQUALLY, PAYMENT, RECORD_PAYMENT]
    end
  end

  has_many :items, :dependent => :destroy
  belongs_to :group_user

  validates_presence_of :cost, :name, :group_user, :transaction_date, :items
  validates_numericality_of :cost
  validates_inclusion_of :transaction_type, :in => Type.all

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

  def payment?
    self.transaction_type == Type::PAYMENT
  end

  private
  
  def decrement_user_balance
    self.user.update_attribute(:net_balance, self.user.reload.net_balance - self.cost)
    self.group_user.update_attribute(:balance, self.group_user.reload.balance - self.cost)
  end

  def increment_user_balance
    if self.group_user
      self.user.update_attribute(:net_balance, self.user.net_balance + self.cost)
      self.group_user.update_attribute(:balance, self.group_user.balance + self.cost)
    end  
  end

end
