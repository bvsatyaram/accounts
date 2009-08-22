class CommonItem < ActiveRecord::Base
  has_many :items, :dependent => :destroy
  belongs_to :group_user

  validates_presence_of :cost, :name
  validates_numericality_of :cost
  validate :cost_must_be_greater_than_zero

  after_create :decrement_user_balance
  after_destroy :increment_user_balance

  define_index do
    indexes :name, :sortable => true
    indexes group_user.user.name, :as => :user_name
    indexes items.user.name, :as => :item_user_name
    indexes cost

    has :created_at, :sortable => true

    # Field weights are assigned based on their specificity.
    set_property :field_weights => {
      :name               => 100,
      :user_name          => 75,
      :item_user_name     => 10,
      :cost               => 20
    }
    #set_property :delta => true
  end

  def self.per_page
    50
  end

  def user
    self.group_user.user
  end

  def group
    self.group_user.group
  end

  protected
  def cost_must_be_greater_than_zero
    errors.add(:cost, 'Pisnaaroda iruavai kanna ekkuva aithene enter chey') if cost.nil?
  end

  private
  
  def decrement_user_balance
    self.user.update_attribute(:net_balance, self.user.net_balance - self.cost)
    self.group_user.update_attribute(:balance, self.group_user.balance - self.cost)
    puts "1111111111111111111111111111111111111111111"
  end

  def increment_user_balance
    self.user.update_attribute(:net_balance, self.user.net_balance + self.cost)
    self.group_user.update_attribute(:balance, self.group_user.balance + self.cost)
    puts "22222222222222222222222222222222222222222222222"
  end

end
