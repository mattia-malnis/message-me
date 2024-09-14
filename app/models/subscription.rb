class Subscription < ApplicationRecord
  belongs_to :profile

  validates :endpoint, :p256dh_key, :auth_key, presence: true
end
