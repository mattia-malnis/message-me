require 'rails_helper'

RSpec.describe Profile, type: :model do
  let(:profile) { FactoryBot.create(:profile) }

  context "associations" do
    it { should belong_to(:user) }
  end

  context "validations" do
    it "is valid with valid attributes" do
      expect(profile).to be_valid
    end

    it "is not valid without a name" do
      profile.name = nil
      expect(profile).not_to be_valid

      profile.name = ""
      expect(profile).not_to be_valid
    end

    it "is not valid with invalid a nickname" do
      profile.nickname = nil
      expect(profile).not_to be_valid

      profile.nickname = "invalid nickname"
      expect(profile).not_to be_valid

      profile.nickname = "invalid.nickname"
      expect(profile).not_to be_valid
    end

    it "is not valid without a user" do
      profile.user = nil
      expect(profile).not_to be_valid
    end

    context "field normalization" do
      let(:user) { FactoryBot.create(:user) }

      it "normalize title" do
        profile = Profile.create({ name: "  My  Name  ", nickname: "MyNickname", user: })
        expect(profile.name).to eq("My Name")
      end
    end
  end
end
