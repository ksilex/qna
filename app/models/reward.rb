class Reward < ApplicationRecord
  FILE_TYPES = %w[image/jpeg image/png image/gif].freeze
  belongs_to :user, optional: true
  belongs_to :question
  has_one_attached :file
  validates :name, presence: true
  validates :file, presence: true
  validate :file_type

  private

  def file_type
    if file.attached? && !FILE_TYPES.include?(file.content_type)
      errors.add(:file, 'Must be a JPG, GIF or PNG file')
    end
  end
end
