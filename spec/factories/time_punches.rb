FactoryBot.define do
  factory :time_punch do
    association :employee
    punched_at { Time.current }
    kind { :clock_in }

    trait :clock_in do
      kind { :clock_in }
    end

    trait :clock_out do
      kind { :clock_out }
    end
  end
end
