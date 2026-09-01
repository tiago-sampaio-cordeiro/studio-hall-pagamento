require 'rails_helper'

RSpec.describe Admin::ReportsController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:employee) { create(:user) }

  describe "GET#index" do
    context "when user is admin" do
      it "it returns success" do
        sign_in admin
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is employee" do
      it "redirects to employee root" do
        sign_in employee
        get :index
        expect(response).to redirect_to(employees_root_path)
      end
    end

    context "when user is not authenticated" do
      it "redirects to login" do
        get :index
        expect(response).to redirect_to(new_session_path)
      end
    end

    context "when employee_id is present" do
      it "renders employee_report template" do
        employee_record = create(:employee)
        sign_in admin
        get :index, params: { employee_id: employee_record.id }
        expect(response).to render_template(:employee_report)
      end
    end

    context "when employee_id is not present" do
      it "renders index template" do
        sign_in admin
        get :index
        expect(response).to render_template(:index)
      end
    end

    context "when params start_date and end_date exists" do
      it "use range params" do
        sign_in admin
        get :index, params: { start_date: Date.new(2026, 1, 1), end_date: Date.new(2026, 1, 1) }
        expect(response).to render_template(:index)
      end
    end

    context "when params start_date and end_date are not exists" do
      it "use current month as range" do
        sign_in admin
        get :index
        expect(response).to render_template(:index)
      end
    end
  end
end