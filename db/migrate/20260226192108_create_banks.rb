class CreateBanks < ActiveRecord::Migration[8.1]
  def change
    create_table :banks do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :name, null: false
      t.string :agency, null: false
      t.string :account, null: false
      t.timestamps
    end
  end
end
