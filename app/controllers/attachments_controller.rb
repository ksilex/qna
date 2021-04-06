class AttachmentsController < ApplicationController
  authorize_resource
  def attachment
    @attachment ||= ActiveStorage::Attachment.find(params[:id])
  end
  helper_method :attachment

  def destroy
    attachment.purge
  end
end
