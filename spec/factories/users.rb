FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email_address { Faker::Internet.unique.email }
    password { "1234" }
    active { true }
    role { :employee }

    trait :admin do
      role { :admin }
    end
  end
end
