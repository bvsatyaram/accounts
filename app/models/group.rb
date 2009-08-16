class Group < ActiveRecord::Base
  acts_as_redeemable

  belongs_to :admin, :class_name => 'User', :foreign_key => :user_id
  belongs_to :redeemed_by, :class_name => "User", :foreign_key => "redeemed_by_id"

  has_many :group_users, :dependent => :destroy

  validates_presence_of :name, :admin

  def get_group_user(user)
    self.group_users.find_by_user_id(user.id)
  end
end
