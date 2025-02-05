module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_current_user
    helper_method :current_user, :user_signed_in?
  end

  private

  def authenticate_user!
    unless user_signed_in?
      redirect_to login_path, alert: "Please sign in to continue."
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def set_current_user
    Current.user = current_user
  end

  def user_signed_in?
    current_user.present?
  end

  def store_location
    session[:return_to] = request.fullpath if request.get?
  end

  def stored_location
    session.delete(:return_to)
  end

  def redirect_back_or(default)
    redirect_to(stored_location || default)
  end
end 