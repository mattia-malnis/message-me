class Chat < ApplicationRecord
  has_secure_token

  has_many :chat_profiles, dependent: :destroy
  has_many :profiles, through: :chat_profiles
  has_many :messages, dependent: :destroy

  def recipient(sender_id)
    profiles.reject { |p| p.id == sender_id }.first
  end
end
