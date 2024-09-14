class PushNotificationService
  def initialize(subscription, message)
    @subscription = subscription
    @message = message
  end

  def notify
    return if @subscription.blank?

    begin
      WebPush.payload_send(
        endpoint: @subscription.endpoint,
        message: JSON.generate(@message),
        p256dh: @subscription.p256dh_key,
        auth: @subscription.auth_key,
        vapid: {
          public_key: Rails.application.credentials.dig(:vapid, :public_key),
          private_key: Rails.application.credentials.dig(:vapid, :private_key),
          subject: Rails.application.credentials.dig(:vapid, :subject)
        }
      )
    rescue StandardError => e
      Rails.logger.error "Failed to send push notification: #{e.message}"
    end
  end
end
