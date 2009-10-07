class GroupUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  has_many :common_items
  has_many :my_common_items, :class_name => "CommonItem", :finder_sql => " SELECT DISTINCT common_items.* FROM common_items,group_users,items
   WHERE ((items.common_item_id = common_items.id AND group_users.user_id = items.user_id AND group_users.id = "+ '#{self.id}' + ") OR
    (common_items.group_user_id = " + '#{self.id}' + " AND  common_items.group_user_id = group_users.id)) AND
    group_users.group_id ="+ '#{self.group_id}' + " ORDER BY id DESC"

  validates_uniqueness_of :user_id, :scope => [:group_id]

  def items
    self.user.items.find_all_by_common_item_id(self.group.common_items.collect(&:id))
  end

  def name(full_name = false)
    full_name ? self.user.name : self.user.display_name
  end
end
