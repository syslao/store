class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :change_role]
  before_action :create_user_type, only: [:new, :owner_new, :admin_new]
  before_action :authorize, except: [:new, :create, :owner_new, :admin_new]

  def index
    if current_user
      @users = User.all
      @messages = current_user.received_messages
    else
      redirect_to root_url, notice: 'Login as Admin'
    end
  end

  def show
    @message = current_user.messages.last
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, notice: 'User was successfully created.'
    elsif @user.role == 'admin'
      render :admin_new
    elsif @user.role == 'owner'
      render :owner_new
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was  destroyed.'
  end

  def change_role
    @user.update_attribute(:role, params[:role])
    redirect_to @user, notice: "Now #{params[:role]}"
  end

  private

  def create_user_type
    @user = User.new
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role, :store_name, :birthday, :user_photo, :user_pasport)
  end
end
