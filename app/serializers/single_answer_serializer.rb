class SingleAnswerSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :body
  belongs_to :user
  has_many :links, serializer: LinkSerializer
  has_many :files, serializer: FileSerializer
  has_many :comments, serializer: CommentSerializer
end
