require "rails_helper"

RSpec.describe EmployeeRegistrationForm, type: :form do
  let(:params) do
    {
      first_name: "John",
      last_name: "Doe",
      email_address: "john@email.com",
      active: true,
      role: "employee",
      password: "password",
      password_confirmation: "password",
      hourly_rate: 100,
      birth_date: Date.new(2026, 1, 1),
      gender: "masculino",
      contract_type: "freelancer",
      phone_number: "5555555555",
      rg: "55555555",
      cpf: "55555555555"
    }
  end

  subject(:form) { described_class.new(params) }

  describe "#save" do
    context "quando os dados são válidos" do
      it "cria um usuário e um funcionário" do
        expect {
          form.save
        }.to change(User, :count).by(1)
                                 .and change(Employee, :count).by(1)
      end

      it "associa o funcionário ao usuário criado" do
        form.save

        employee = Employee.last

        expect(employee.user).to be_present
        expect(employee.user.email_address).to eq(params[:email_address])
      end

      it "retorna true" do
        expect(form.save).to be true
      end
    end

    context "quando os dados são inválidos" do
      it "não cria registros sem CPF" do
        invalid_params = params.merge(cpf: nil)

        form = described_class.new(invalid_params)

        expect(form.save).to be false
        expect(User.count).to eq(0)
        expect(Employee.count).to eq(0)
      end

      it "adiciona erros ao formulário" do
        invalid_params = params.merge(cpf: nil)

        form = described_class.new(invalid_params)

        form.save

        expect(form.errors[:cpf]).to be_present
      end
    end

    context "quando está editando um funcionário" do
      let!(:user) do
        create(
          :user,
          first_name: "Old",
          email_address: "old@email.com"
        )
      end

      let!(:employee) do
        create(
          :employee,
          user: user,
          contract_type: "freelancer",
          hourly_rate: 50,
          birth_date: Date.new(2020, 1, 1),
          gender: "masculino",
          cpf: "11111111111",
          rg: "11111111"
        )
      end

      let(:update_form) do
        described_class.new(
          params.merge(
            user_id: user.id,
            first_name: "John Updated",
            email_address: "novo@email.com"
          )
        )
      end

      it "atualiza o usuário" do
        update_form.save

        expect(user.reload.first_name).to eq("John Updated")
        expect(user.email_address).to eq("novo@email.com")
      end

      it "atualiza o funcionário" do
        update_form.save

        expect(employee.reload.hourly_rate).to eq(100)
      end
    end
  end
end