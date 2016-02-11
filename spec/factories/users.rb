FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'
    role 3
    group
  end
end
