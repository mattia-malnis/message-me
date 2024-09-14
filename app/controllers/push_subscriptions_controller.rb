class PushSubscriptionsController < ApplicationController
  include FindProfile

  skip_before_action :verify_authenticity_token
  prepend_before_action :authenticate_user!

  def create
    subscription = @profile.build_subscription

    if subscription.update(subscription_params)
      render json: { message: "Subscription registered successfully" }, status: :created
    else
      render json: { errors: subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:endpoint, :p256dh_key, :auth_key)
  end
end
