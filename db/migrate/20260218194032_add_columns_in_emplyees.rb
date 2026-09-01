class AddColumnsInEmplyees < ActiveRecord::Migration[8.1]
  def change
    add_reference :employees, :user, null: false, foreign_key: true
    add_column :employees, :employment_type, :integer, null: false, default: 0
    add_column :employees, :base_salary, :decimal, precision: 10, scale: 2
    add_column :employees, :hourly_rate, :decimal, precision: 10, scale: 2
    add_column :employees, :hire_date, :date
    # without position
    add_index :employees, :employment_type
  end
end
