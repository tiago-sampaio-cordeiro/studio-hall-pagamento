class RemoveRelashionshipInEmployee < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key :banks, :employees
    remove_foreign_key :pix_keys, :employees
    remove_foreign_key :phones, :employees
  end
end
