FactoryGirl.define do
  factory :group do
    name "kahalai"
    organisation

    factory :group_with_users do
      transient do
        users_count 5
      end

      after(:create) do |group, evaluator|
        create_list(:user, evaluator.users_count, group: group)
      end
    end
  end
end
