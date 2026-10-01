FactoryBot.define do
  factory :employee do
    association :user
    birth_date { Faker::Date.between(from: "1985-01-01", to: "2005-12-31") }
    gender { Faker::Gender.binary_type }
    position { Faker::Job.position }
    rg { Faker::Number.decimal_part(digits: 10) }
    contract_type { :clt }
    salary { 2000 }
    hourly_rate { nil }
    admission_date { Faker::Date.between(from: "2024-01-01", to: Date.current) }
    cpf { Faker::IdNumber.brazilian_citizen_number }
    phone_number { Faker::PhoneNumber.cell_phone }

    trait :clt do
      contract_type { :clt }
      salary { 2000 }
      hourly_rate { nil }
    end

    trait :freelancer do
      contract_type { :freelancer }
      salary { nil }
      hourly_rate { 50 }
    end
  end
end
