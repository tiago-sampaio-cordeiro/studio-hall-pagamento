require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:employee) { create(:user) }

  describe "GET #index" do
    context "when user is admin" do
      it "returns success" do
        sign_in admin
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is employee" do
      it "redirects to employees root" do
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
  end
end