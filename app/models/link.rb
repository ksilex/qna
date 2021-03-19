class Link < ApplicationRecord
  belongs_to :parent, polymorphic: true
  validates :name, :url, presence: true
end
