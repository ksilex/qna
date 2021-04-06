class LinksController < ApplicationController
  authorize_resource
  def link
    @link ||= Link.find(params[:id])
  end
  helper_method :link

  def destroy
    link.destroy
  end
end
