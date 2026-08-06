require 'rails_helper'

RSpec.describe Register::EmployeeRecords, type: :service do
  def default_params
    {
      email_address: Faker::Internet.unique.email,
      password: "1234",
      password_confirmation: "1234",
      role: :admin,
      active: true,
      first_name: Faker::Artist.name,
      last_name: Faker::Name.last_name,
      hourly_rate: nil,
      salary: 2000,
      address: Faker::Address.full_address,
      admission_date: Faker::Date.between(from: "2024-01-01", to: Date.current),
      birth_date: Faker::Date.between(from: "1985-01-01", to: "2005-12-31"),
      cnpj: Faker::IdNumber.brazilian_citizen_number(formatted: false),
      contract_type: :clt,
      ctps: Faker::IdNumber.brazilian_citizen_number(formatted: false),
      gender: Faker::Gender.binary_type,
      phone_number: Faker::PhoneNumber.cell_phone,
      pis: Faker::IdNumber.brazilian_citizen_number(formatted: false),
      pix_key: Faker::Number.decimal_part(digits: 10),
      position: Faker::Job.position,
      rg: Faker::Number.decimal_part(digits: 10),
      cpf: Faker::IdNumber.brazilian_citizen_number,
      mother_name: Faker::Artist.name,
      mother_last_name: Faker::Name.last_name,
      emergency_phone_number: Faker::PhoneNumber.cell_phone,
      nationality: Faker::Nation.nationality,
      city_born: Faker::Address.city,
      uf_born: Faker::Address.country_code,
      blood_group: Faker::Blood.rh_factor,
      allergies: "nenhuma",
      driver_license: Faker::DrivingLicence.british_driving_licence,
      driver_license_category: "AB",
      driver_license_number: Faker::IdNumber.brazilian_citizen_number,
      cep: Faker::Address.zip_code,
      house_number: Faker::Address.building_number,
      neighborhood: Faker::Address.street_name,
      city: Faker::Address.city,
      uf_live: Faker::Address.country_code,
      reference: Faker::Commerce.brand
    }
  end

  describe "call" do
    it "create employee correctly" do
      result = Register::EmployeeRecords.new(**default_params,user_id: :user).call

      expect(result).to be_a(Employee)
    end

    it "update employee correctly" do
      employee = Register::EmployeeRecords.new(**default_params, user_id: nil).call
      result = Register::EmployeeRecords.new(**default_params,user_id: employee.user_id).update

      expect(result).to be(true)
    end
  end
end