require 'rails_helper'

RSpec.describe PushNotificationService do
  let(:subscription) { FactoryBot.create(:subscription) }
  let(:message) do
    {
      title: "New message",
      options: { body: "Test notification", data: { path: "/chats" } }
    }
  end

  subject { described_class.new(subscription, message) }

  describe "#notify" do
    context "when subscription is valid" do
      it "sends a web push notification" do
        expect(WebPush).to receive(:payload_send).with(
          endpoint: subscription.endpoint,
          message: JSON.generate(message),
          p256dh: subscription.p256dh_key,
          auth: subscription.auth_key,
          vapid: hash_including(:public_key, :private_key, :subject)
        )

        subject.notify
      end
    end

    context "when there is a general error" do
      before do
        allow(WebPush).to receive(:payload_send).and_raise(StandardError.new("Something went wrong"))
      end

      it "logs the error" do
        expect(Rails.logger).to receive(:error).with(/Failed to send push notification/)
        subject.notify
      end
    end
  end
end
