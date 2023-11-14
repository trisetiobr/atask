class ApplicationController < ActionController::Base
  before_action :require_login

  private

  def current_user
    @current_user ||= User.find(session[:user_id])

    @current_user
  end

  def require_login
    unless logged_in?
      if request.path == root_path
        redirect_to login_path
      else
        render 'users/login'
      end
    end
  end

  def logged_in?
    session[:user_id].present?
  end
end
