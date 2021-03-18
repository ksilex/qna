class Link < ApplicationRecord
  belongs_to :parent, polymorphic: true
end
