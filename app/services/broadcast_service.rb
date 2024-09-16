class BroadcastService
  def initialize(profile, recipient, chat)
    @profile = profile
    @recipient = recipient
    @chat = chat
  end

  def notify
    return if @profile.blank? || @recipient.blank? || @chat.blank?

    Turbo::StreamsChannel.broadcast_append_to(
      "sidebar_profile_#{@recipient.nickname}",
      target: "sidebar_chats",
      partial: "chats/chat_item",
        locals: { chat: @chat, recipient: @profile, new_msg: true }
    )
  end
end
