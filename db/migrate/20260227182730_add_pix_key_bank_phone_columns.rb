class AddPixKeyBankPhoneColumns < ActiveRecord::Migration[8.1]
  def change
    add_column :employees, :pix_key, :string
    add_column :employees, :phone_number, :string
  end
end
