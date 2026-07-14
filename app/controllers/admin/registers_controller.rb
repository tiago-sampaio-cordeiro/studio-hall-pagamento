class Admin::RegistersController < ApplicationController
  before_action :require_admin

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    service = Register::EmployeeRecords.new(
      user_attrs: user_params,
      employee_attrs: employee_params
    )

    if service.call
      redirect_to admin_registers_path, notice: "Funcionário cadastrado com sucesso!"
    else
      @errors = service.errors
      @user = User.new(user_params)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    service = Register::EmployeeRecords.new(
      user_attrs: user_params,
      employee_attrs: employee_params,
      user_id: params[:id]
    )

    if service.update
      redirect_to admin_registers_path, notice: "Funcionário atualizado com sucesso!"
    else
      @errors = service.errors
      @user = User.find(params[:id])
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :email_address, :active, :role,
      :password, :password_confirmation
    ).to_h.reject { |_, v| v.blank? }
  end

  def employee_params
    params.require(:user).permit(
      :hourly_rate, :birth_date, :gender, :admission_date,
      :contract_type, :salary, :position, :phone_number, :rg, :cpf
    ).to_h.reject { |_, v| v.blank? }
  end
end