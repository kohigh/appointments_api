class CreateAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :appointments do |t|
      t.references :dentist, foreign_key: { to_table: :users, on_delete: :cascade }
      t.references :patient, foreign_key: { to_table: :users, on_delete: :cascade }
      t.date :day
      t.integer :slot

      t.timestamps
    end

    add_index :appointments, [:dentist_id, :day, :slot], unique: true
  end
end
