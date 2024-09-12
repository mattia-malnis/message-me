class ChatsController < ApplicationController
  include FindProfile

  prepend_before_action :authenticate_user!
  before_action :set_chat, only: [:show, :update]
  before_action :set_recipient, only: [:show, :update]

  def index
    @chats = @profile.chats.includes(:profiles)
  end

  def show
    @messages = @chat.messages.includes(:profile).ordered
  end

  def update
    @message = @chat.messages.new(message_params)
    @message.profile = @profile
    @message.save
    broadcast_new_message
  end

  private

  def broadcast_new_message
    Turbo::StreamsChannel.broadcast_append_to(
      "sidebar_profile_#{@recipient.nickname}",
      target: "sidebar-chats",
      partial: "chats/chat",
        locals: { chat: @chat, recipient: @profile, new_msg: true }
    )
  end

  def set_chat
    @chat = @profile.chats.find_by!(token: params[:token])
  end

  def set_recipient
    @recipient = @chat.recipient(@profile.id)
  end

  def message_params
    params.require(:messages).permit(:content)
  end
end
