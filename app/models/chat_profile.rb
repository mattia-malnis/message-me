class ChatProfile < ApplicationRecord
  belongs_to :chat
  belongs_to :profile
end
