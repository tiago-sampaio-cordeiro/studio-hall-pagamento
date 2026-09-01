class Employees::ReportsController < ApplicationController
  def index
    range = build_range
    @results = Reports::EmployeeDailyReport.new(employee: current_employee, range: range).call
  end

  private

  def current_employee
    if Current.user.admin? && params[:employee_id].present?
      Employee.find(params[:employee_id])
    else
      Current.user.employee
    end
  end

  def build_range
    if params[:start_date].present? && params[:end_date].present?
      Date.parse(params[:start_date]).beginning_of_day..Date.parse(params[:end_date]).end_of_day
    else
      Date.current.beginning_of_month.beginning_of_day..Date.current.end_of_month.end_of_day
    end
  end
end