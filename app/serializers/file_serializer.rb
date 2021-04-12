class FileSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :url, :filename, :created_at

  def filename
    object.filename.to_s
  end

  def url
    "localhost:3000#{rails_blob_path(object, only_path: true)}"
  end
end
