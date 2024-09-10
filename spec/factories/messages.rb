FactoryBot.define do
  factory :message do
    content { FFaker::Lorem.paragraph }
    chat
    profile
  end
end
