class ApplicationController < ActionController::Base
  before_action :current_user_js, unless: :devise_controller?
  def current_user_js
    gon.current_user = current_user&.id
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  check_authorization unless: :devise_controller?
end
