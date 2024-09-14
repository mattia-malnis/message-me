require 'rails_helper'

RSpec.describe "PushSubscriptions", type: :request do
  let!(:profile) { FactoryBot.create(:profile) }
  let(:valid_attributes) { { subscription: { endpoint: "https://example.com", p256dh_key: "key", auth_key: "auth" } } }
  let(:invalid_attributes) { { subscription: { endpoint: "" } } }

  describe "POST /subscribe" do
    context "with valid params" do
      it "register a subscription" do
        sign_in profile.user
        post subscribe_path, params: valid_attributes, as: :json
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["message"]).to eq("Subscription registered successfully")
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors" do
        sign_in profile.user
        post subscribe_path, params: invalid_attributes, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key("errors")
      end
    end
  end
end
