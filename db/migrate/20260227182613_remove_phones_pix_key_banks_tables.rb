class RemovePhonesPixKeyBanksTables < ActiveRecord::Migration[8.1]
  def change
    drop_table :banks
    drop_table :pix_keys
    drop_table :phones
  end
end
