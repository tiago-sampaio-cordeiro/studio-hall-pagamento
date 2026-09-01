require 'rails_helper'

RSpec.describe Employees::TimePunchesController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:employee_user) { create(:employee).user }

  describe "GET#index" do
    context "when user is employee" do
      it "returns http success" do
        sign_in employee_user
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is admin" do
      it "redirects to admin root" do
        sign_in admin
        get :index
        expect(response).to redirect_to(admin_root_path)
      end
    end

    context "when user is not authenticated" do
      it "redirects to login" do
        get :index
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "POST#create" do
    context "when user is admin" do
      it "redirects to admin root" do
        sign_in admin
        post :create, params: { kind: :clock_in }
        expect(response).to redirect_to(admin_root_path)
      end
    end

    context "when user is employee" do
      it "creates time_punch and returns success with notice" do
        sign_in employee_user
        post :create, params: { kind: :clock_in }
        expect(response).to redirect_to(employees_time_punches_path)
        expect(flash[:notice]).to eq("Ponto registrado com sucesso!")
      end
    end

    context "when clock_out is before 15 minutes" do
      it "redirect to time punches index with notice" do
        create(:time_punch, employee: employee_user.employee, kind: :clock_in, punched_at: Time.current)
        sign_in employee_user
        post :create, params: { kind: :clock_out }
        expect(response).not_to redirect_to(employees_time_punches_path)
        expect(flash[:alert]).to eq("Aguarde 15 minutos!")
      end
    end

    context "when user is not authenticated" do
      it "redirects to login" do
        post :create, params: { kind: :clock_in }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end