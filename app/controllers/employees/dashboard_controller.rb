module Employees
  class DashboardController < ApplicationController
    before_action :require_employee

    def index
      @employee = Current.user.employee
      range = Time.zone.now.beginning_of_month..Time.zone.now.end_of_month

      @daily_results = Reports::EmployeeDailyReport.new(employee: @employee, range: range).call

      punches = Reports::EmployeeTimePunchesQuery.new(employee: @employee, range: range).call
      @total_hours = PaymentCalculation::HoursCalculator.new(punches: punches).call
      @estimated_payment = PaymentCalculation::Payment.new(employee: @employee, worked_hours: @total_hours).call

      @goal_hours = PaymentCalculation::Payment::STANDARD_MONTHLY_HOURS
      @goal_percent = [(@total_hours / @goal_hours.to_f * 100), 100].min

      @daily_hours_chart = build_daily_hours_chart
    end

    private

    # o EmployeeDailyReport formata as horas como "HH:MM:SS" (pra exibição na tabela),
    # então convertemos de volta pra decimal aqui só pra alimentar o gráfico
    def build_daily_hours_chart
      @daily_results.map do |r|
        h, m, s = r[:total_hours].split(":").map(&:to_i)
        decimal_hours = h + (m / 60.0) + (s / 3600.0)
        [r[:date].strftime("%d/%m"), decimal_hours.round(2)]
      end
    end
  end
end