class ApplicationController < ActionController::Base
  before_action :current_user_js, unless: :devise_controller?
  def current_user_js
    gon.current_user = current_user.id if current_user
  end
end
