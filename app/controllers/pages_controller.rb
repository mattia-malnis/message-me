class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:temp_page]

  def index
  end

  def temp_page
    render plain: "WIP"
  end
end
