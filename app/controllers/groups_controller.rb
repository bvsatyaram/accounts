class GroupsController < ApplicationController

  def new
    @group = Group.new(:user_id => current_user.id)
  end

  def create
    @group = Group.build(params[:group])
    @group.user = current_user
    if @group.save
      @group.group_users.create!(:user_id => current_user.id)
      flash[:notice] = "Your group has been successfully created"
    else
      render :action => 'new'
    end
  end

  def update
    
  end

  def destroy

  end

end
