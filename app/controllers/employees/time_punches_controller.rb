class Employees::TimePunchesController < ApplicationController
  before_action :require_employee
  helper_method :next_punch_kind


  def index
  end

  def create
    if can_register_punch?
      time_clock = TimeClock::EmployeeTimeClock.new(
        employee: Current.user.employee,
        kind: time_clocks_params[:kind],
        punched_at: DateTime.current).call
      redirect_to employees_time_punches_path, notice: "Ponto registrado com sucesso!"
    else
      flash.now[:alert] = "Aguarde 5 minutos!"
      render :index, status: :unprocessable_entity
    end
  end

  def next_punch_kind
    Current.user.employee.next_punch_kind
  end

  private

  def time_clocks_params
    params.permit(:kind)
  end

  def can_register_punch?
    last_punch = Current.user.employee.time_punches.order(:punched_at).last
    return true if last_punch.nil? || last_punch.clock_out?
    last_punch.punched_at + 5.minutes <= Time.current
  end
end
