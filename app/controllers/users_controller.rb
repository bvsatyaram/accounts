class UsersController < ApplicationController
  skip_before_filter :require_login, :only => [:new, :create]

  def new
    if params[:group_code]
      @group = Group.find_by_code(params[:group_code])
      handle_invalid_code
      if current_user
        @user = current_user
        create_group_user_and_redirect
      end
    end
    @user = User.new
  end

  def create
    handle_group_invite and return if params[:group_code]
        
    @user = User.new(params[:user])
    if @user.save
      redirect_to user_url(@user)
    else
      render :action => "new"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfull updated your profile"
      redirect_to user_path(@user)
    else
      render :action => "edit"
    end
  end

  def show
    redirect_to groups_path
  end

  def index
    
  end

  private

  def handle_group_invite
    @group = Group.find_by_code(params[:group_code])
    handle_invalid_code

    @user = User.new(params[:user])
    if @user.save
      create_group_user_and_redirect
    else
      render :action => "new"
    end
  end

  def handle_invalid_code
    unless @group
      flash[:error] = "Invalid code. Try joining the group with proper url"
      redirect_to root_url and return
    end
  end

  def create_group_user_and_redirect
    @group.users << @user if @group
    redirect_to user_url(@user)
  end
end
