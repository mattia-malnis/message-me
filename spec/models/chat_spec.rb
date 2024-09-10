require 'rails_helper'

RSpec.describe Chat, type: :model do
  context "associations" do
    it { should have_many(:chat_profiles).dependent(:destroy) }
    it { should have_many(:profiles).through(:chat_profiles) }
    it { should have_many(:messages).dependent(:destroy) }
  end
end
