class CreatePixKeys < ActiveRecord::Migration[8.1]
  def change
    create_table :pix_keys do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :number
      t.timestamps
    end
  end
end
