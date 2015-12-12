class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :authorize
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  private

  def current_user
    User.where(id: session[:user_id]).first
  end

  def authorize
    redirect_to login_url, alert: 'Not authorized! Please log in.' if current_user.nil?
  end
end
