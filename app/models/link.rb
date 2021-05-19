class Link < ApplicationRecord
  belongs_to :parent, polymorphic: true, touch: true

  validates :name, :url, presence: true
  validates :url,
            format: { with:    %r{\A(http|https)://[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(/.*)?\z}ix,
                      message: 'Invalid url format' }
end
