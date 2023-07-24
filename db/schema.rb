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

ActiveRecord::Schema[7.0].define(version: 2023_07_24_121052) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointments", force: :cascade do |t|
    t.bigint "dentist_id"
    t.bigint "patient_id"
    t.date "day"
    t.integer "slot"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dentist_id", "day", "slot"], name: "index_appointments_on_dentist_id_and_day_and_slot", unique: true
    t.index ["dentist_id"], name: "index_appointments_on_dentist_id"
    t.index ["patient_id"], name: "index_appointments_on_patient_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "appointments", "users", column: "dentist_id", on_delete: :cascade
  add_foreign_key "appointments", "users", column: "patient_id", on_delete: :cascade
end
