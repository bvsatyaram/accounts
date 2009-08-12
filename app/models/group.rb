class Group < ActiveRecord::Base

  belongs_to :admin, :class_name => 'User', :foreign_key => :user_id
  has_many :group_users, :dependent => :destroy

  validates_presence_of :name, :admin

  def get_group_user(user)
    self.group_users.find_by_user_id(user.id)
  end
end
