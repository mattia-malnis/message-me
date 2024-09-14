FactoryBot.define do
  factory :subscription do
    endpoint { FFaker::Internet.http_url }
    p256dh_key { FFaker::Internet.password }
    auth_key { FFaker::Internet.password }
    profile
  end
end
