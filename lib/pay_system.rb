class PaySystem
  attr_accessor :user, :group, :payers, :receivers

  def initialize(user, group)
    self.user = user
    self.group = group
    self.payers = Hash.new
    self.receivers = Hash.new
    self.get_payers_receivers
  end

  def self.user_pay_structure(user, group)
    ps = self.new(user, group)
    return nil if user.balance == 0
    ps.calculate
    return (user.balance > 0) ? ps.payers[user.id] : ps.receivers[user.id]
  end

  def get_payers_receivers
    self.group.group_users.find(:all, :conditions => "balance > 0", :order => "balance DESC").each do |user|
      self.payers[user.id] = PayUser.new(user)
    end
    self.group.group_users.find(:all, :conditions => "balance < 0", :order => "balance ASC").each do |user|
      self.receivers[user.id] = PayUser.new(user)
    end
  end

  def highest_payer
    hp = self.payers.values.sort{|v, u| u.new_balance <=> v.new_balance }[0]
    return hp if hp.new_balance > 0
  end

  def highest_receiver
    hr = self.receivers.values.sort{|v, u| v.new_balance <=> u.new_balance }[0]
    return hr if hr.new_balance < 0
  end

  def calculate
    hp = self.highest_payer
    hr = self.highest_receiver
    if hp && hr
      if hp.new_balance > (-1 * hr.new_balance)
        hp.transaction_partners[hr.user] = -1 * hr.new_balance
        hr.transaction_partners[hp.user] =  -1 * hr.new_balance

        hp.new_balance = hp.new_balance + hr.new_balance
        hr.new_balance = 0
        
      else
        hr.transaction_partners[hp.user] = hp.new_balance
        hp.transaction_partners[hr.user] = hp.new_balance

        hr.new_balance = hp.new_balance + hr.new_balance
        hp.new_balance = 0
      end
      self.calculate
    end
    return
  end

  class PayUser
    attr_accessor :user, :new_balance, :transaction_partners

    def initialize(user)
      self.user = user
      self.new_balance = user.balance
      self.transaction_partners = Hash.new
    end
  end
end