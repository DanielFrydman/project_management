class RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!
  layout "auth"

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    return render :new, status: :unprocessable_entity unless @user.save

    session[:user_id] = @user.id
    redirect_to projects_path, notice: "Welcome! Your account has been created."
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :name)
  end
end
