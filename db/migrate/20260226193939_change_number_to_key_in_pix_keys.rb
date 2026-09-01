class ChangeNumberToKeyInPixKeys < ActiveRecord::Migration[8.1]
  def change
    rename_column :pix_keys, :number, :key
  end
end
