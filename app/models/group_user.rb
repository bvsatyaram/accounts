class GroupUser < ActiveRecord::Base

  belongs_to :user
  belongs_to :group

  has_many :common_items

  validates_uniqueness_of :user_id, :scope => [:group_id]

  def items
    self.user.items.find_all_by_common_item_id(self.group.common_items.collect(&:id))
  end
end
