class SingleQuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at
  belongs_to :user
  has_many :answers
  has_many :links, serializer: LinkSerializer
  has_many :files, serializer: FileSerializer
  has_many :comments, serializer: CommentSerializer
end
