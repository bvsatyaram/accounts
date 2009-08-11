class Group < ActiveRecord::Base

  belongs_to :admin, :class_name => 'User', :foreign_key => :user_id
  has_many :group_users, :dependent => :destroy
end
