class RemoveUnusedFieldsFromEmployees < ActiveRecord::Migration[8.1]
  def change
    remove_column :employees, :address, :string
    remove_column :employees, :allergies, :string
    remove_column :employees, :blood_group, :string
    remove_column :employees, :cep, :string
    remove_column :employees, :city, :string
    remove_column :employees, :city_born, :string
    remove_column :employees, :cnpj, :string
    remove_column :employees, :ctps, :string
    remove_column :employees, :driver_license, :string
    remove_column :employees, :driver_license_category, :string
    remove_column :employees, :driver_license_number, :string
    remove_column :employees, :emergency_phone_number, :string
    remove_column :employees, :house_number, :string
    remove_column :employees, :mother_last_name, :string
    remove_column :employees, :mother_name, :string
    remove_column :employees, :nationality, :string
    remove_column :employees, :neighborhood, :string
    remove_column :employees, :pis, :string
    remove_column :employees, :pix_key, :string
    remove_column :employees, :reference, :string
    remove_column :employees, :uf_born, :string
    remove_column :employees, :uf_live, :string
  end
end
