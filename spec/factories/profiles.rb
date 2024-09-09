FactoryBot.define do
  factory :profile do
    name { FFaker::Name.first_name }
    nickname { FFaker::InternetSE.login_user_name }
    bio { FFaker::Lorem.sentence }
    user
  end
end
