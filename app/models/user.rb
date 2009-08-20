class User < ActiveRecord::Base
  acts_as_authentic

  validates_presence_of :name

  has_many :group_users, :dependent => :destroy
  has_many :groups, :through => :group_users
  has_many :admin_groups, :class_name => "Group"

  has_many :items
end
