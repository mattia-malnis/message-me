class ChatsController < ApplicationController
  include FindProfile

  prepend_before_action :authenticate_user!
  before_action :set_chat, only: [:show]

  def index
    @chats = @profile.chats.includes(:profiles)
  end

  def show
    @messages = @chat.messages.includes(:profile).ordered
    @recipient = @chat.recipient(@profile.id)
  end

  private

  def set_chat
    @chat = @profile.chats.find_by!(token: params[:token])
  end
end
