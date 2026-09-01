# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_10_232821) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "employees", force: :cascade do |t|
    t.string "address"
    t.date "admission_date"
    t.string "allergies"
    t.date "birth_date", null: false
    t.string "blood_group"
    t.string "cep"
    t.string "city"
    t.string "city_born"
    t.string "cnpj"
    t.integer "contract_type", default: 0, null: false
    t.string "cpf"
    t.datetime "created_at", null: false
    t.string "ctps"
    t.string "driver_license"
    t.string "driver_license_category"
    t.string "driver_license_number"
    t.string "emergency_phone_number"
    t.string "gender", null: false
    t.decimal "hourly_rate", precision: 10, scale: 2
    t.string "house_number"
    t.string "mother_last_name"
    t.string "mother_name"
    t.string "nationality"
    t.string "neighborhood"
    t.string "phone_number"
    t.string "pis"
    t.string "pix_key"
    t.string "position"
    t.string "reference"
    t.string "rg"
    t.decimal "salary", precision: 10, scale: 2
    t.string "uf_born"
    t.string "uf_live"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_employees_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "time_punches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "employee_id", null: false
    t.integer "kind", null: false
    t.datetime "punched_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id", "punched_at"], name: "index_time_punches_on_employee_id_and_punched_at"
    t.index ["employee_id"], name: "index_time_punches_on_employee_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "employees", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "time_punches", "employees"
end
