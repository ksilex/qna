class AttachmentsController < ApplicationController
  
  def attachment
    @attachment ||= ActiveStorage::Attachment.find(params[:id])
  end
  helper_method :attachment

  def destroy
    unless current_user.author?(attachment.record)
      redirect_to root_path, notice: 'Cant perfom such action' 
    else 
      attachment.purge
    end
  end
end