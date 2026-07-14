require 'rails_helper'

RSpec.describe Admin::EmployeesController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:employee) { create(:user) }

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

  describe "GET #index" do
    context "when user is admin" do
      it "returns success" do
        sign_in admin
        get :index
        expect(response).to have_http_status(:success)
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

  describe "GET #show" do
    context "when user is admin" do
      it "returns success" do
        sign_in admin
        get :show, params: {id: employee}
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is employee" do
      it "redirects to employees root" do
        sign_in employee
        get :show, params: {id: employee}
        expect(response).to redirect_to(employees_root_path)
      end
    end

    context "when user is not authenticated" do
      it "redirects to login" do
        get :show, params: {id: employee}
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "GET #new" do
    context "when user is admin" do
      it "returns success" do
        sign_in admin
        get :new
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is employee" do
      it "redirects to employees root" do
        sign_in employee
        get :new
        expect(response).to redirect_to(employees_root_path)
      end
    end

    context "when user is not authenticated" do
      it "redirects to login" do
        get :new
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "GET #edit" do
    context "when user is admin" do
      it "returns success" do
        sign_in admin
        get :edit, params: {id: employee}
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is employee" do
      it "redirects to employees root" do
        sign_in employee
        get :edit, params: {id: employee}
        expect(response).to redirect_to(employees_root_path)
      end
    end

    context "when user is not authenticated" do
      it "redirects to login" do
        get :edit, params: {id: employee}
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "POST #create" do
    context "when user is admin" do
      it "creates employee and redirects with notice" do
        sign_in admin
        post :create, params: default_params
        expect(response).to redirect_to(admin_registers_path)
        expect(flash[:notice]).to eq("Funcionário cadastrado com sucesso!")
      end
    end

    context "when user is employee" do
      it "redirects to employees root" do
        sign_in employee
        post :create, params: default_params
        expect(response).to redirect_to(employees_root_path)
      end
    end

    context "when user is not authenticated" do
      it "redirects to login" do
        post :create, params: default_params
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "PATCH #update" do
    context "when user is admin" do
      it "update employee and redirects with notice" do
        user_with_employee = create(:employee).user
        sign_in admin
        patch :update, params: default_params.merge(id: user_with_employee.id)
        expect(response).to redirect_to(admin_registers_path)
        expect(flash[:notice]).to eq("Funcionário atualizado com sucesso!")
      end
    end

    context "when user is employee" do
      it "redirects to employees root" do
        sign_in employee
        patch :update, params: { id: employee.id }
        expect(response).to redirect_to(employees_root_path)
      end
    end

    context "when user is not authenticated" do
      it "redirects to login" do
        patch :update, params: { id: employee.id }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end


end