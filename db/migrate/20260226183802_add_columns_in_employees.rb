class AddColumnsInEmployees < ActiveRecord::Migration[8.1]
  def change
    add_column :employees, :birth_date, :date, null: false
    add_column :employees, :gender, :string, null: false
    add_column :employees, :admission_date, :date
    add_column :employees, :contract_type, :integer, default: 0, null: false
    add_column :employees, :address, :string, null: false
    add_column :employees, :salary, :decimal, precision: 10, scale: 2
    add_column :employees, :pis, :string
    add_column :employees, :ctps, :string
    add_column :employees, :position, :string
    add_column :employees, :cnpj, :string
  end
end
