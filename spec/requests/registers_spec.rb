require 'rails_helper'

RSpec.describe Register, type: :request do
  let(:admin) { create(:user, :admin) }
  let(:employee) { create(:employee).user }

  def default_params
    {
      user: {
        email_address: Faker::Internet.unique.email,
        password: "1234",
        password_confirmation: "1234",
        role: :admin,
        active: true,
        first_name: Faker::Artist.name,
        last_name: Faker::Name.last_name,
        hourly_rate: nil,
        salary: 2000,
        admission_date: Faker::Date.between(from: "2024-01-01", to: Date.current),
        birth_date: Faker::Date.between(from: "1985-01-01", to: "2005-12-31"),
        contract_type: :clt,
        gender: Faker::Gender.binary_type,
        phone_number: Faker::PhoneNumber.cell_phone,
        position: Faker::Job.position,
        rg: Faker::Number.decimal_part(digits: 10),
        cpf: Faker::IdNumber.brazilian_citizen_number,
      }
    }
  end

  describe "POST /admin/register" do
    context "admin registers employee" do
      it "create employee in the database" do
        post session_path, params: {
          email_address: admin.email_address,
          password: admin.password
        }

        expect {
          post admin_employees_path, params: default_params
        }.to change(Employee, :count).by(1)

      end
    end
  end
end
