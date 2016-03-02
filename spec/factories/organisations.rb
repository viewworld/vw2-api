FactoryGirl.define do
  factory :organisation do
    name "RERA"
    use "project_monitoring"

    factory :organisation_with_groups do
      transient do
        groups_count 5
      end

      after(:create) do |organisation, evaluator|
        create_list(:group, evaluator.groups_count, organisation: organisation)
      end
    end
  end
end
