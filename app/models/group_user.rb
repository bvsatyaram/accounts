class GroupUser < ActiveRecord::Base

  belongs_to :user
  belongs_to :group

  has_many :common_items

  validates_uniqueness_of :user_id, :scope => [:group_id]
end
