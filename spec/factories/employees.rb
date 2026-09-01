FactoryBot.define do
  factory :employee do
    association :user
    address { Faker::Address.full_address }
    birth_date { Faker::Date.between(from: "1985-01-01", to: "2005-12-31") }
    cnpj { Faker::IdNumber.brazilian_citizen_number(formatted: false) }
    ctps { Faker::IdNumber.brazilian_citizen_number(formatted: false) }
    gender { Faker::Gender.binary_type }
    pis { Faker::IdNumber.brazilian_citizen_number(formatted: false) }
    pix_key { Faker::Number.decimal_part(digits: 10) }
    position { Faker::Job.position }
    rg { Faker::Number.decimal_part(digits: 10) }
    mother_name { Faker::Artist.name }
    mother_last_name { Faker::Name.last_name }
    emergency_phone_number { Faker::PhoneNumber.cell_phone }
    nationality { Faker::Nation.nationality }
    city_born { Faker::Address.city }
    uf_born { Faker::Address.country_code }
    blood_group { Faker::Blood.rh_factor }
    allergies { "nenhuma" }
    driver_license { Faker::DrivingLicence.british_driving_licence }
    driver_license_category { "AB" }
    driver_license_number { Faker::IdNumber.brazilian_citizen_number }
    cep { Faker::Address.zip_code }
    house_number { Faker::Address.building_number }
    neighborhood { Faker::Address.street_name }
    city { Faker::Address.city }
    uf_live { Faker::Address.country_code }
    reference { Faker::Commerce.brand }
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
