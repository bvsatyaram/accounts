class PaySystem
  attr_accessor :group_user, :group, :payers, :receivers

  def initialize(group_user)
    self.group_user = group_user
    self.group = group_user.group
    self.payers = Hash.new
    self.receivers = Hash.new
    self.get_payers_receivers
  end

  def self.user_pay_structure(group_user)
    ps = self.new(group_user)
    return nil if group_user.balance == 0
    ps.calculate
    return (group_user.balance > 0) ? ps.payers[group_user.id] : ps.receivers[group_user.id]
  end

  def get_payers_receivers
    self.group.group_users.find(:all, :conditions => "balance > 0", :order => "balance DESC").each do |group_user|
      self.payers[group_user.id] = PayUser.new(group_user)
    end
    self.group.group_users.find(:all, :conditions => "balance < 0", :order => "balance ASC").each do |group_user|
      self.receivers[group_user.id] = PayUser.new(group_user)
    end
  end

  def highest_payer
    hp = self.payers.values.sort{|v, u| u.new_balance <=> v.new_balance }[0]
    return hp if hp && hp.new_balance > 0
  end

  def highest_receiver
    hr = self.receivers.values.sort{|v, u| v.new_balance <=> u.new_balance }[0]
    return hr if hr && hr.new_balance < 0
  end

  def calculate
    hp = self.highest_payer
    hr = self.highest_receiver
    if hp && hr
      if hp.new_balance > (-1 * hr.new_balance)
        hp.transaction_partners[hr.group_user] = -1 * hr.new_balance
        hr.transaction_partners[hp.group_user] =  -1 * hr.new_balance

        hp.new_balance = hp.new_balance + hr.new_balance
        hr.new_balance = 0
        
      else
        hr.transaction_partners[hp.group_user] = hp.new_balance
        hp.transaction_partners[hr.group_user] = hp.new_balance

        hr.new_balance = hp.new_balance + hr.new_balance
        hp.new_balance = 0
      end
      self.calculate
    end
    return
  end

  class PayUser
    attr_accessor :group_user, :new_balance, :transaction_partners

    def initialize(group_user)
      self.group_user = group_user
      self.new_balance = group_user.balance
      self.transaction_partners = Hash.new
    end
  end
end