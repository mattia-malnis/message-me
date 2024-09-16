require 'rails_helper'

RSpec.describe BroadcastService do
  let(:profile) { FactoryBot.create(:profile) }
  let(:recipient) { FactoryBot.create(:profile) }
  let(:chat) { FactoryBot.create(:chat, profiles: [profile, recipient]) }

  subject { described_class.new(profile, recipient, chat) }

  describe "#notify" do
    it "broadcasts the new message" do
      expect(Turbo::StreamsChannel).to receive(:broadcast_append_to).with(
        "sidebar_profile_#{recipient.nickname}",
        target: "sidebar_chats",
        partial: "chats/chat_item",
        locals: { chat: chat, recipient: profile, new_msg: true }
      )
      subject.notify
    end
  end
end
