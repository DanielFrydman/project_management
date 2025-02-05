class SessionsController < ApplicationController
  skip_before_action :authenticate_user!
  layout "auth"

  def new
  end

  def create
    user = User.find_by(email: params[:email]&.downcase)

    return invalid_credentials unless user&.authenticate(params[:password])

    session[:user_id] = user.id
    redirect_to projects_path, notice: "Welcome back!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "You have been logged out."
  end

  private

  def invalid_credentials
    flash.now[:alert] = "Invalid email or password"
    render :new, status: :unprocessable_entity
  end
end
