# app/controllers/users_controller.rb
class UsersController < ApplicationController
  skip_before_action :require_login

  def login
    @user = User.new
  end

  def authenticate
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to dashboard_path, notice: 'Logged in successfully'
    else
      flash.now[:alert] = 'Invalid email or password'
      render :login
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged out successfully'
  end
end
