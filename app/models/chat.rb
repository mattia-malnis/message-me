class Chat < ApplicationRecord
  has_secure_token

  has_many :chat_profiles, dependent: :destroy
  has_many :profiles, through: :chat_profiles
  has_many :messages, dependent: :destroy

  def recipient(sender_id)
    profiles.reject { |p| p.id == sender_id }.first
  end

  def self.find_chat_for_profiles(profile1, profile2)
    joins(:chat_profiles)
    .where(chat_profiles: { profile_id: [profile1.id, profile2.id] })
    .group("chats.id")
    .having("COUNT(DISTINCT chat_profiles.profile_id) = 2")
    .first
  end
end
