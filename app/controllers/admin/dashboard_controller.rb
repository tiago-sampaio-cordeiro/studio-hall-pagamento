module Admin
  class DashboardController < ApplicationController
    before_action :require_admin

    def index
      range = Time.zone.now.beginning_of_month..Time.zone.now.end_of_month
      @results = Reports::AdminEmployeesPaymentReport.new(range: range).call
      @total_payroll = @results.sum { |r| r[:amount] }
      @hours_chart_series = build_hours_chart_series
      @contract_type_counts = build_contract_type_counts
    end

    private

    def build_hours_chart_series
      below_goal = {}
      above_goal = {}

      @results.each do |r|
        name = "#{r[:employee].user.first_name} #{r[:employee].user.last_name}"
        if r[:hours] < PaymentCalculation::Payment::STANDARD_MONTHLY_HOURS
          below_goal[name] = r[:hours].round(2)
        else
          above_goal[name] = r[:hours].round(2)
        end
      end

      [
        { name: "Abaixo da meta (176h)", data: below_goal, color: "#ef4444" },
        { name: "Acima ou igual à meta (176h)", data: above_goal, color: "#10b981" }
      ]
    end

    def build_contract_type_counts
      {
        "CLT" => Employee.where(contract_type: :clt).count,
        "Freelancer" => Employee.where(contract_type: :freelancer).count
      }
    end
  end
end