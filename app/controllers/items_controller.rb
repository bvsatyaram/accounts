class ItemsController < ApplicationController
  def index
    user = User.find(params[:user_id])
    @items = user.items.paginate(:page => params[:page], :per_page => params[:per_page] || 50)
  end

  def pay_structure
    @pay_structure = PaySystem.new(current_user)
    @pay_structure.calculate
  end

end
