require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:message) { FactoryBot.create(:message) }

  context "associations" do
    it { should belong_to(:profile) }
    it { should belong_to(:chat) }
  end

  context "validations" do
    it "is valid with valid attributes" do
      expect(message).to be_valid
    end

    it "is not valid without content" do
      message.content = nil
      expect(message).not_to be_valid
    end
  end

  context "content normalization" do
    let(:profile) { FactoryBot.create(:profile) }

    it "normalize title" do
      msg = Message.create({ content: "  Lorem ipsum dolor sit amet, consectetur adipiscing elit  ", profile: })
      expect(msg.content).to eq("Lorem ipsum dolor sit amet, consectetur adipiscing elit")
    end
  end
end
