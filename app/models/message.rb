class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :profile

  scope :ordered, -> { order(created_at: :asc) }
end
