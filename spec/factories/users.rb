FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'
    group
    trait :sysadmin do
      after(:create) { |user| user.role = :sysadmin }
    end

    trait :admin do
      after(:create) { |user| user.role = :admin }
    end

    trait :user do
      after(:create) { |user| user.role = :user }
    end

    trait :editor do
      after(:create) { |user| user.role = :editor }
    end
  end
end
