class ApplicationController < ActionController::Base
  before_action :current_user_js, unless: :devise_controller?
  def current_user_js
    gon.current_user = current_user&.id
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.json { head :forbidden }
      format.js   { head :forbidden }
    end
  end
end
