require 'rails_helper'

RSpec.describe "Chats", type: :request do
  let(:profile) { FactoryBot.create(:profile) }
  let(:user) { FactoryBot.create(:user) }

  describe "GET /chats" do
    context "when user has a profile" do
      it "returns http success" do
        sign_in profile.user
        get chats_path
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
      end
    end

    context "when user has no profile" do
      it "redirects to the edit profile path" do
        sign_in user
        get chats_path
        expect(response).to redirect_to(edit_profile_path)
      end
    end
  end

  describe "authentication" do
    it "redirects to login page if not signed in" do
      get chats_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
