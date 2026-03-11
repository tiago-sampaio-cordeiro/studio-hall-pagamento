require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:employee) { create(:user) }

  describe "POST /session" do
    context "admin with valid credentials" do
      it "redirects to dashboard" do
        post session_path, params: {
          email_address: admin.email_address,
          password: admin.password
        }
        expect(response).to redirect_to(admin_root_path)
      end
    end

    context "admin with invalid credentials" do
      it "redirects to login" do
        post session_path, params: {
          email_address: "email@errado",
          password: "password#errado"
        }
        expect(response).to redirect_to(new_session_path)
      end
    end

    context "employee with valid credentials" do
      it "redirects to dashboard" do
        post session_path, params: {
          email_address: employee.email_address,
          password: employee.password
        }
        expect(response).to redirect_to(employees_root_path)
      end
    end

    context "employee with invalid credentials" do
      it "redirects to login" do
        post session_path, params: {
          email_address: "email@errado",
          password: "password#errado"
        }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end