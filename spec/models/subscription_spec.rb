require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:subscription) { FactoryBot.create(:subscription) }

  it { should belong_to(:profile) }

  context "validations" do
    it "is valid with valid attributes" do
      expect(subscription).to be_valid
    end

    it "is not valid without endpoint" do
      subscription.endpoint = nil
      expect(subscription).not_to be_valid
    end

    it "is not valid without p256dh_key" do
      subscription.p256dh_key = nil
      expect(subscription).not_to be_valid
    end

    it "is not valid without auth_key" do
      subscription.auth_key = nil
      expect(subscription).not_to be_valid
    end
  end
end
