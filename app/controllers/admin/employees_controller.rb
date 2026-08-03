class Admin::EmployeesController < ApplicationController
  before_action :require_admin

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @form = EmployeeRegistrationForm.new
  end

  def create
    @form = EmployeeRegistrationForm.new(registration_params)

    if @form.save
      redirect_to admin_employees_path, notice: "Funcionário cadastrado com sucesso!"
    else
      puts "ERROS DE VALIDAÇÃO: #{@form.errors.full_messages}"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    user = User.find(params[:id])
    @form = EmployeeRegistrationForm.from_user(user)
  end

  def update
    @form = EmployeeRegistrationForm.new(registration_params.merge(user_id: params[:id]))

    if @form.save
      redirect_to admin_employees_path, notice: "Funcionário atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.require(:user).permit(
      :first_name, :last_name, :email_address, :active, :role, :password, :password_confirmation,
      :hourly_rate, :birth_date, :gender, :admission_date, :contract_type,
      :salary, :position, :phone_number, :rg, :cpf
    )
  end
end