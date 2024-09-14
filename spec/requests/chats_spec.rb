require 'rails_helper'

RSpec.describe "Chats", type: :request do
  let(:profile) { FactoryBot.create(:profile) }
  let(:profile1) { FactoryBot.create(:profile) }
  let(:profile2) { FactoryBot.create(:profile) }
  let(:subscription) { FactoryBot.create(:subscription, profile: profile2) }
  let(:user) { FactoryBot.create(:user) }
  let(:chat) { FactoryBot.create(:chat) }
  let(:message_params) { { content: "Test message" } }

  before do
    allow(Rails.application.credentials).to receive(:dig).with(:vapid, :public_key).and_return("test")
    allow(Rails.application.credentials).to receive(:dig).with(:vapid, :private_key).and_return("123456")
    allow(Rails.application.credentials).to receive(:dig).with(:vapid, :subject).and_return("mailto:test@test.com")
  end

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

  describe "PATCH /chats/:token" do
    context "when message is created successfully" do
      it "creates a new message" do
        chat.profiles = [profile1, profile2]
        sign_in profile1.user
        expect {
            patch chat_path(chat.token), params: { messages: message_params }, as: :turbo_stream
          }.to change(Message, :count).by(1)
      end

      it "broadcasts the new message" do
        chat.profiles = [profile1, profile2]
        sign_in profile1.user

        expect(Turbo::StreamsChannel).to receive(:broadcast_append_to).with(
          "sidebar_profile_#{profile2.nickname}",
          target: "sidebar-chats",
          partial: "chats/chat",
          locals: { chat: chat, recipient: profile1, new_msg: true }
        )

        patch chat_path(chat.token), params: { messages: message_params }, as: :turbo_stream
      end

      it "notifies the recipient" do
        chat.profiles = [profile1, profile2]
        sign_in profile1.user

        expect(subscription).to be_present

        service = instance_double(PushNotificationService, notify: true)
        allow(PushNotificationService).to receive(:new).and_return(service)

        patch chat_path(chat.token), params: { messages: message_params }, as: :turbo_stream

        expect(PushNotificationService).to have_received(:new).with(
          profile2.subscription,
          hash_including(
            title: "You have a new message!",
            options: hash_including(body: "#{profile1.name} sent you a message")
          )
        )
        expect(service).to have_received(:notify)
      end
    end
  end

  context "when message fails to save" do
    it "does not create a message" do
      chat.profiles = [profile1, profile2]
      sign_in profile1.user

      expect {
        patch chat_path(chat.token), as: :turbo_stream
      }.not_to change(Message, :count)
    end
  end

  describe "authentication" do
    it "redirects to login page if not signed in" do
      get chats_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
