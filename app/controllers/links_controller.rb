class LinksController < ApplicationController
  def link
    @link ||= Link.find(params[:id])
  end
  helper_method :link

  def destroy
    unless current_user.author?(link.parent)
      redirect_to root_path, notice: 'Cant perfom such action'
    else
      link.destroy
    end
  end
end
