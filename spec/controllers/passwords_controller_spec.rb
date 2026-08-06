require 'rails_helper'

RSpec.describe PasswordsController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:employee) { create(:user) }

  describe "GET#new" do
    context "render /passwords/new" do
      it "render template" do
        get :new
        expect(response).to render_template(:new)
      end
    end
  end

  describe "POST#create" do
    context "when user is admin and had valid email" do
      it "redirects to login" do
        sign_in admin
        post :create, params: { email_address: admin.email_address }
        expect(response).to redirect_to(new_session_path)
      end
    end

    context "when user is admin and had not valid email" do
      it "redirects to login" do
        sign_in admin
        post :create, params: { email_address: "email@errado" }
        expect(response).to redirect_to(new_session_path)
        expect(flash[:notice]).to eq("Instruções para redefinição de senha enviadas (caso exista um usuário com esse endereço de e-mail).")
      end
    end

    context "when user is employee and had valid email" do
      it "redirects to login" do
        sign_in employee
        post :create, params: { email_address: admin.email_address }
        expect(response).to redirect_to(new_session_path)
      end
    end

    context "when user is employee and had not valid email" do
      it "redirects to login" do
        sign_in employee
        post :create, params: { email_address: "email@errado" }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "PATCH#update" do
    context "when user is admin and had valid token with equals passwords" do
      it "redirects to login" do
        token = admin.password_reset_token
        patch :update, params: { token: token, password: "1234", password_confirmation: "1234" }
        expect(response).to redirect_to(new_session_path)
        expect(flash[:notice]).to eq("Senha foi redefinida com sucesso!")
      end
    end

    context "when user is admin and had valid token with different passwords" do
      it "redirects to edit" do
        token = admin.password_reset_token
        patch :update, params: { token: token, password: "1234", password_confirmation: "12345" }
        expect(response).to redirect_to(edit_password_path)
        expect(flash[:alert]).to eq("Senha e repetição da senha precisam ser iguais!")
      end
    end

    context "when user is admin and had invalid token" do
      it "redirects to edit" do
        patch :update, params: { token: "invalid#token", password: "1234", password_confirmation: "1234" }
        expect(response).to redirect_to(new_password_path)
        expect(flash[:alert]).to eq("Link de redefinição de senha é inválido ou expirou!")
      end
    end

    context "when user is employee and had valid token with equals passwords" do
      it "redirects to login" do
        token = employee.password_reset_token
        patch :update, params: { token: token, password: "1234", password_confirmation: "1234" }
        expect(response).to redirect_to(new_session_path)
        expect(flash[:notice]).to eq("Senha foi redefinida com sucesso!")
      end
    end

    context "when user is employee and had valid token with different passwords" do
      it "redirects to edit" do
        token = employee.password_reset_token
        patch :update, params: { token: token, password: "1234", password_confirmation: "12345" }
        expect(response).to redirect_to(edit_password_path)
        expect(flash[:alert]).to eq("Senha e repetição da senha precisam ser iguais!")
      end
    end

    context "when user is employee and had invalid token" do
      it "redirects to edit" do
        patch :update, params: { token: "invalid#token", password: "1234", password_confirmation: "1234" }
        expect(response).to redirect_to(new_password_path)
        expect(flash[:alert]).to eq("Link de redefinição de senha é inválido ou expirou!")
      end
    end
  end
end