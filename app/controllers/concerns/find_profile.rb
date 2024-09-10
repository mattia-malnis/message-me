module FindProfile
  extend ActiveSupport::Concern

  included do
    before_action :set_profile
    before_action :check_profile_existence
  end

  private

  def set_profile
    @profile = current_user.profile
  end

  def check_profile_existence
    return if @profile.present?

    redirect_to edit_profile_path, alert: "Please complete your profile before proceeding."
  end
end
