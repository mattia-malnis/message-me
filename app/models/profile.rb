class Profile < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :nickname, presence: true, format: { with: /\A[a-zA-Z0-9_-]+\z/ }
  validates :nickname, uniqueness: { case_sensitive: false }, if: :nickname_changed?

  before_validation :normalize_fields

  private

  def normalize_fields
    self.name = name.try(:squish)
  end
end
