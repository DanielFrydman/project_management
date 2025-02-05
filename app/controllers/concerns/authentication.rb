module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    helper_method :current_user, :user_signed_in?
  end

  private

  def authenticate_user!
    return if user_signed_in?

    redirect_to login_path, alert: "Please sign in to continue."
  end

  def current_user
    return unless session[:user_id]

    user ||= User.find_by(id: session[:user_id])
    Current.user ||= user
    @current_user ||= user
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
