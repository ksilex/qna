class LinksController < ApplicationController
  def link
    @link ||= Link.find(params[:id])
  end
  helper_method :link

  def destroy
    authorize! :destroy, link
    link.destroy
  end
end
