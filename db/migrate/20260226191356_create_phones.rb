class CreatePhones < ActiveRecord::Migration[8.1]
  def change
    create_table :phones do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :number, null: false
      t.timestamps
    end
  end
end
