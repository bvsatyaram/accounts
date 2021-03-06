class User < ActiveRecord::Base
  acts_as_authentic

  validates_presence_of :name

  has_many :group_users, :dependent => :destroy
  has_many :groups, :through => :group_users

  has_many :active_group_users, :class_name => "GroupUser", :conditions => {:status => GroupUser::Status::ACTIVE}
  has_many :active_groups, :through => :active_group_users, :source => :group

  has_many :admin_groups, :class_name => "Group"
  has_many :items

  attr_protected :app_admin

  def display_name
    self.nick_name || self.name
  end
end
