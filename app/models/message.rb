class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :profile

  broadcasts_refreshes_to :chat

  validates :content, presence: true

  scope :ordered, -> { order(created_at: :asc) }

  before_validation :normalize_content

  private

  def normalize_content
    self.content = content.try(:strip)
  end
end
