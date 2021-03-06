class GroupsController < ApplicationController
  
  def new
    @group = Group.new()
  end

  def create
    @group = Group.new(params[:group])
    @group.admin = current_user
    if @group.save
      @group.group_users.create!(:user_id => current_user.id)
      flash[:notice] = "Your group has been successfully created"
      redirect_to groups_path
    else
      render :action => 'new'
    end
  end

  def index
    @groups = current_user.active_groups
  end

  def show
    @group = current_user.active_groups.find(params[:id])
    redirect_to group_common_items_path(@group)
  end

  def destroy
    @group = current_user.admin_groups.find(params[:id])
    @group.destroy
    flash[:notice] = "Your group has been successfully destroyed"
    redirect_to groups_path
  end
  
end