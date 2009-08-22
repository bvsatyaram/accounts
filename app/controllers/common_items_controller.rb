class CommonItemsController < ApplicationController
  before_filter :find_group
  allow :exec => :check_auth
  
  def new
    @common_item = @group_user.common_items.new
    @users = @group.users
  end

  def create
    @common_item = @group_user.common_items.new(params[:common_item])
    @users = @group.users

    if params[:index]
      handle_index_page_creation and return
    end

    unless params[:user_ids]
      flash[:error]="Select atleast one user"
      render :action =>  :new and return
    end
    
    if @common_item.save
      Item.create_items(params[:user_ids], @common_item)
      flash[:notice]= "Emi konnava kaani andariki Bokka pettav"
      if params[:add_another] == "0"
        redirect_to :action => :index
      else
        @common_item = CommonItem.new()
        render :action =>  :new and return
      end
    else
      flash[:notice]= @common_item.errors.full_messages.to_sentence
      render :action =>  :new and return
    end

  end

  def index
    @common_items = @group.common_items.paginate(:page => params[:page]||1, :per_page => params[:per_page]||50, :order => "id desc")
    @users = @group.users
    @total_cost = @common_items? @common_items.collect(&:cost).sum : 0
    @new_common_item = @group.common_items.new(:group_user_id => @group_user.id)
  end

  def destroy
    @common_item = CommonItem.find(params[:id])
    if @common_item.destroy
      flash[:notice] = "Successfully deleted"
    end
    redirect_to group_common_items_path(@group)
  end

  private

  def handle_index_page_creation
    if @common_item.save
      params[:item_cost].keys.each do |key|
        @common_item.items.create(:user_id => key, :default_amount => params[:item_cost][key], :name => @common_item.name) unless params[:item_cost][key].blank? || params[:item_cost][key] == "0"
      end
    end
    redirect_to :action => :index
  end

  def find_group
    @group = current_user.groups.find(params[:group_id])
    @group_user = @group.get_group_user(current_user)
  end

  def check_auth
    @group.users.include?(current_user)
  end
end
