require 'rails_helper'

RSpec.describe Employees::ReportsController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:employee_user) { create(:employee).user }

  describe "GET#index" do
    context "when user is employee" do
      it "returns success" do
        sign_in employee_user
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is admin" do
      it "returns success" do
        sign_in admin
        get :index, params: { employee_id: create(:employee).id }
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not authenticated" do
      it "redirects to login" do
        get :index
        expect(response).to redirect_to(new_session_path)
      end
    end

    context "when params start_date and end_date exists" do
      it "use range params" do
        sign_in employee_user
        get :index, params: { start_date: "2026-01-01", end_date: "2026-01-31" }
        expect(response).to render_template(:index)
      end
    end

    context "when params start_date and end_date are not exists" do
      it "use current month as range" do
        sign_in employee_user
        get :index
        expect(response).to render_template(:index)
      end
    end
  end
end