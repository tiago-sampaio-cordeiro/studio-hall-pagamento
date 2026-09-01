class RenameDriverLicenceColumns < ActiveRecord::Migration[8.1]
  def change
    rename_column :employees, :driver_licence, :driver_license
    rename_column :employees, :driver_licence_category, :driver_license_category
  end
end
