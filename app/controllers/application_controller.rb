class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate_active_admin_user!
    authenticate_user! 
    unless current_user.admin?
      flash[:alert] = "This area is restricted to administrators only"
      redirect_to root_path
    end
  end

  before_filter :set_locale

  private 

  # Server-side locale. Client side locale is set at crespon_app.js
  def set_locale
    I18n.locale = "en"
  end

end
