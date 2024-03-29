class Api::V1::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :doorkeeper_authorize!

  private

  def current_user
    @current_user ||= User.find_by(id: doorkeeper_token&.resource_owner_id)
  end
end
