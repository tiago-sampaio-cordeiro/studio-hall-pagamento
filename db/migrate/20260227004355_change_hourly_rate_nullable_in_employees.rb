class ChangeHourlyRateNullableInEmployees < ActiveRecord::Migration[8.1]
  def change
    change_column_null :employees, :hourly_rate, true
  end
end
