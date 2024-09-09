require 'rails_helper'

RSpec.describe "Profiles", type: :request do
  let(:profile) { FactoryBot.create(:profile) }
  let(:user) { FactoryBot.create(:user) }

  describe "GET /profile" do
    context "when user has a profile" do
      it "returns http success" do
        sign_in profile.user
        get profile_path
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show)
      end
    end

    context "when user has no profile" do
      it "redirects to the edit profile path" do
        sign_in user
        get profile_path
        expect(response).to redirect_to(edit_profile_path)
      end
    end
  end

  describe "GET /profile/edit" do
    it "returns http success" do
      sign_in profile.user
      get edit_profile_path
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT /profile" do
    context "when user has no profile" do
      it "creates a new profile" do
        sign_in user
        put profile_path, params: { profile: { name: "Name", nickname: "Nickname", bio: "Bio" } }
        expect(response).to redirect_to(profile_path)
        expect(user.reload.profile.name).to eq("Name")
      end
    end

    context "when user has a profile" do
      it "updates the profile successfully" do
        sign_in profile.user
        put profile_path, params: { profile: { name: "Updated Name", nickname: "UpdatedNickname", bio: "Updated Bio" } }
        expect(response).to redirect_to(profile_path)
        expect(profile.reload.name).to eq("Updated Name")
      end

      it "renders edit page with errors on validation failure" do
        sign_in profile.user
        put profile_path, params: { profile: { name: "", nickname: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end
    end

    describe "authentication" do
      it "redirects to login page if not signed in" do
        get profile_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
