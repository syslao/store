class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

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


  def new
    @user = User.new
  end

  def owner_new
    @user = User.new
  end

  def admin_new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, notice: 'User was successfully created.'
    elsif @user.role_id == 1
      render :admin_new
    elsif @user.role_id == 2
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
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def change_role
    role_message = ""
    @user = User.find(params[:id])
    if params['role'] == '1'
      @user.update_attribute(:role_id, 1)
      role_message = 'Now Admin'
    elsif params['role'] == '2'
      @user.update_attribute(:role_id, 2)
      role_message = 'Now Owner'
    else params['role'] == '3'
      @user.update_attribute(:role_id, 3)
      role_message = 'Now Guest'
    end
    redirect_to @user, notice: role_message
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role_id,:store_name, :birthday, :user_photo, :user_pasport)
  end

end
