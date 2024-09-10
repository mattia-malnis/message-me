class ChatsController < ApplicationController
  include FindProfile

  prepend_before_action :authenticate_user!
  before_action :set_chat, only: [:show, :update]

  def index
    @chats = @profile.chats.includes(:profiles)
  end

  def show
    @messages = @chat.messages.includes(:profile).ordered
    @recipient = @chat.recipient(@profile.id)
  end

  def update
    @message = @chat.messages.new(message_params)
    @message.profile = @profile
    @message.save
  end

  private

  def set_chat
    @chat = @profile.chats.find_by!(token: params[:token])
  end

  def message_params
    params.require(:messages).permit(:content)
  end
end
