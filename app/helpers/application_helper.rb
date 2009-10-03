# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def user_transaction_partners(group_user)
    payer = PaySystem.user_pay_structure(group_user)
    payer.blank? ? {} : payer.transaction_partners
  end

  def transaction_statement(group_user)
    trans = user_transaction_partners(group_user)
    string = ""
    trans.keys.each do |trans_user|
      user_name = GroupUser.find(trans_user).user.name
      string += content_tag(:span, :class => "trans_user") do
        if group_user.balance > 0
          "Pay Rs. #{trans[trans_user]} to <b> #{user_name} </b>"
        else
          "Get Rs. #{trans[trans_user]} from <b> #{user_name} </b>"
        end
      end
      string += "<br>"
    end
    return string
  end
  
end
