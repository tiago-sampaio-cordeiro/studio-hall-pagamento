require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:session) { create(:session) }
  let(:employee) { create(:employee) }

  describe "validations" do
    context "with valid attributes" do
      it "is valid" do
        user =  create(:user)
        expect(user).to be_valid
      end
    end

    context "without email_address" do
      it "is invalid" do
        user =  build(:user, email_address: nil)
        expect(user).not_to be_valid
      end
    end

    context "without password" do
      it "is invalid" do
        user =  build(:user, password: nil)
        expect(user).not_to be_valid
      end
    end
  end

  describe "associations" do
    context "has many sessions" do
      it "its true" do
        user =  create(:user)
        create(:session, user: user)
        create(:session, user: user)

        expect(user.sessions.count).to eq(2)
      end
    end

    context "has one employee" do
      it "its true" do
        employee = create(:employee)

        expect(employee.user.employee).to eq(employee)
      end
    end
  end

  describe "enum" do
    context "role" do
      it "employee and admin are valid roles" do
        employee = build(:user)
        admin = build(:user, :admin)
        expect(employee.employee?).to be true
        expect(admin.admin?).to be true
      end
    end
  end

  describe "normalization" do
    context "email" do
      it "normalizes email to lowercase and without spaces" do
        user = create(:user, email_address: "  EMAIL@TESTE.COM  ")
        expect(user.email_address).to eq("email@teste.com")
      end
    end

    context "email" do
      it "normalizes email to lowercase and without spaces" do
        user = create(:user, email_address: "      email@teste.com   ")
        expect(user.email_address).to eq("email@teste.com")
      end
    end
  end
end