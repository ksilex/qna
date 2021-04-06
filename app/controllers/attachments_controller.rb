class AttachmentsController < ApplicationController
  def attachment
    @attachment ||= ActiveStorage::Attachment.find(params[:id])
  end
  helper_method :attachment

  def destroy
    authorize! :destroy, attachment
    attachment.purge
  end
end
