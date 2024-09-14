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

    if @message.save
      broadcast_new_message
      notify_recipient
    end
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

  def notify_recipient
    return if @recipient.subscription.blank?

    message = {
      title: "You have a new message!",
      options: {
        body: "#{@profile.name} sent you a message",
        data: { path: chats_path }
      }
    }

    PushNotificationService.new(@recipient.subscription, message).notify
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
