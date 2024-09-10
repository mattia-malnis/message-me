class ProfilesController < ApplicationController
  include FindProfile

  prepend_before_action :authenticate_user!
  before_action :set_or_build_profile, only: [:edit, :update]
  before_action :check_profile_existence, only: [:show]

  def show
    @profile = current_user.profile
  end

  def edit
  end

  def update
    if @profile.update(profile_params)
      redirect_to profile_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_or_build_profile
    @profile ||= current_user.build_profile
  end

  def profile_params
    params.require(:profile).permit(:name, :nickname, :bio)
  end
end
