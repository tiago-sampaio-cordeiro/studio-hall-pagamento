class AddMoreColumnsInEmployeeTable < ActiveRecord::Migration[8.1]
  def change
    add_column :employees, :rg, :string
    add_column :employees, :cpf, :string
    add_column :employees, :mother_name, :string
    add_column :employees, :mother_last_name, :string
    add_column :employees, :emergency_phone_number, :string
    add_column :employees, :nationality, :string
    add_column :employees, :city_born, :string
    add_column :employees, :uf_born, :string
    add_column :employees, :blood_group, :string
    add_column :employees, :allergies, :string
    add_column :employees, :driver_licence, :string
    add_column :employees, :driver_licence_category, :string
    add_column :employees, :driver_license_number, :string
    add_column :employees, :cep, :string
    add_column :employees, :house_number, :string
    add_column :employees, :neighborhood, :string
    add_column :employees, :city, :string
    add_column :employees, :uf_live, :string
    add_column :employees, :reference, :string
  end
end
