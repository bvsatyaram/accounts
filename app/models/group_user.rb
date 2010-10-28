class GroupUser < ActiveRecord::Base
  module Status
    ACTIVE    = 0
    SUSPENDED = 1
  end
  
  belongs_to :user
  belongs_to :group

  has_many :common_items, :dependent => :destroy

  named_scope :payers, :conditions => ["balance > 0"]
  named_scope :receivers, :conditions => ["balance < 0"]

  named_scope :active, :conditions => {:status => Status::ACTIVE}
  named_scope :suspended, :conditions => {:status => Status::SUSPENDED}
  
  validates_uniqueness_of :user_id, :scope => [:group_id]
  validates_inclusion_of  :status, :in => [Status::ACTIVE, Status::SUSPENDED]
  validate :check_balance_before_suspension

  before_create :set_status_to_active

  def items
    self.user.items.find_all_by_common_item_id(self.group.common_items.collect(&:id))
  end

  def name(full_name = false)
    full_name ? self.user.name : self.user.display_name
  end
  
  def active?
    self.status == Status::ACTIVE
  end

  def suspend!
    self.update_attributes(:status => Status::SUSPENDED)
  end

  def activate!
    self.update_attributes!(:status => Status::ACTIVE)
  end

  def can_be_suspend?
    self.balance == 0
  end

  private

  def check_balance_before_suspension
    if !self.can_be_suspend? && !self.active?
      errors.add(:status, "cannot be suspended when having a non zero credit")
    end
  end

  def set_status_to_active
    self.status = Status::ACTIVE
  end
end
