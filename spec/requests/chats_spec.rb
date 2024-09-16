require 'rails_helper'

RSpec.describe "Chats", type: :request do
  let(:profile) { FactoryBot.create(:profile) }
  let(:recipient) { FactoryBot.create(:profile) }
  let!(:chat) { FactoryBot.create(:chat, profiles: [profile, recipient]) }
  let(:user) { FactoryBot.create(:user) }
  let(:subscription) { FactoryBot.create(:subscription, profile: recipient) }
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
        sign_in profile.user
        expect {
            patch chat_path(chat.token), params: { messages: message_params }, as: :turbo_stream
          }.to change(Message, :count).by(1)
      end

      it "broadcasts the new message" do
        sign_in profile.user

        service = instance_double(BroadcastService, notify: true)
        allow(BroadcastService).to receive(:new).and_return(service)

        patch chat_path(chat.token), params: { messages: message_params }, as: :turbo_stream
        expect(BroadcastService).to have_received(:new).with(profile, recipient, chat)
      end

      it "notifies the recipient" do
        sign_in profile.user

        expect(subscription).to be_present

        service = instance_double(PushNotificationService, notify: true)
        allow(PushNotificationService).to receive(:new).and_return(service)

        patch chat_path(chat.token), params: { messages: message_params }, as: :turbo_stream

        expect(PushNotificationService).to have_received(:new).with(
          recipient.subscription,
          hash_including(
            title: "You have a new message!",
            options: hash_including(body: "#{profile.name} sent you a message")
          )
        )
        expect(service).to have_received(:notify)
      end
    end
  end

  context "when message fails to save" do
    it "does not create a message" do
      sign_in profile.user

      expect {
        patch chat_path(chat.token), as: :turbo_stream
      }.not_to change(Message, :count)
    end
  end

  describe "GET /chats/search " do
    context "when query is blank" do
      it "returns all chats for the current profile" do
        sign_in profile.user
        get search_chats_path, params: { query: "" }
        expect(assigns(:chats)).to include(chat)
      end
    end

    context "when query is present" do
      let!(:matching_profile) { FactoryBot.create(:profile, name: "John Doe") }
      let!(:non_matching_profile) { FactoryBot.create(:profile, name: "Jane Smith") }

      it "returns matching profiles except the current profile" do
        sign_in profile.user
        get search_chats_path, params: { query: "John" }
        expect(assigns(:profiles)).to include(matching_profile)
        expect(assigns(:profiles)).not_to include(non_matching_profile, profile)
      end
    end
  end

  describe "GET /chats/new " do
    context "when a chat already exists" do
      it "finds the existing chat" do
        sign_in profile.user
        get new_chat_path, params: { token: recipient.token }
        expect(assigns(:chat)).to eq(chat)
        expect(response).to render_template(:show)
      end
    end

    context "when a chat does not exists" do
      let(:new_recipient) { FactoryBot.create(:profile) }

      it "creates a new chat" do
        sign_in profile.user
        expect {
          get new_chat_path, params: { token: new_recipient.token }
        }.to change(Chat, :count).by(1)
        expect(assigns(:chat).profiles).to include(profile, new_recipient)
        expect(response).to render_template(:show)
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
