class CreatePayrolls < ActiveRecord::Migration[8.1]
  def change
    create_table :payrolls do |t|
      t.references :employee, null: false, foreign_key: true
      t.date :reference_month, null: false
      t.decimal :base_amount, precision: 10, scale: 2, null: false, default: 0
      t.decimal :extra_amount, precision: 10, scale: 2, null: false, default: 0
      t.decimal :discount_amount, precision: 10, scale: 2, null: false, default: 0
      t.decimal :total_amount, precision: 10, scale: 2, null: false, default: 0

      t.boolean :locked, null: false, default: false
      t.timestamps
    end
    add_index :payrolls, [ :employee_id, :reference_month ], unique: true
  end
end
