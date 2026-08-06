require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:employee) { create(:user) }

  describe 'GET#new' do
    context "render /sessions/new" do
      it "render template" do
        get :new
        expect(response).to render_template(:new)
      end
    end
  end

  describe "POST#create" do
    context "when user has employee credentials and are valid" do
      it "redirects to dashboard" do
        post :create, params: { email_address: employee.email_address, password: employee.password }
        expect(response).to redirect_to(employees_root_path)
      end
    end

    context "when user has admin credentials and are valid" do
      it "redirects to dashboard" do
        post :create, params: { email_address: admin.email_address, password: admin.password }
        expect(response).to redirect_to(admin_root_path)
      end
    end

    context "when user has not credentials valid" do
      it "redirects to new_session_path" do
        post :create, params: { email_address: "email@errado", password: "password#errado" }
        expect(response).to redirect_to(new_session_path)
        expect(flash[:alert]).to eq("Email ou senha errados, tente novamente")
      end
    end
  end

  describe "DELETE#destroy" do
    context "when user is admin and log out" do
      it "redirects to new_session_path" do
        sign_in admin
        delete :destroy
        expect(response).to redirect_to(new_session_path)
      end
    end

    context "when user is employee and log out" do
      it "redirects to new_session_path" do
        sign_in employee
        delete :destroy
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end