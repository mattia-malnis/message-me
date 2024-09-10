FactoryBot.define do
  factory :chat do
    token { FFaker::UUID.uuidv4 }
  end
end
