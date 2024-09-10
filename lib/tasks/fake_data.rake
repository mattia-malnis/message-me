namespace :fake_data do
  desc "Create fake users and profiles"
  task :users, [:count] => :environment do |t, args|
    count = (args[:count] || 100).to_i

    puts "Creating #{count} users..."
    count.times do
      User.create({
        email: FFaker::Internet.email,
        password: "12345678"
      })
    end

    puts "Creating profiles..."
    User.left_outer_joins(:profile).where(profile: { id: nil }).each do |user|
      user.create_profile({
        name: FFaker::Name.first_name,
        nickname: FFaker::Internet.user_name.gsub(".", "-"),
        bio: FFaker::Lorem.sentence
      })
    end
  end
end
