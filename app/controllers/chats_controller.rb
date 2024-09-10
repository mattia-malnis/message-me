class ChatsController < ApplicationController
  include FindProfile

  prepend_before_action :authenticate_user!

  def index
    @chats = @profile.chats.includes(:profiles)
  end
end
