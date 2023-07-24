# frozen_string_literal: true

class User < ApplicationRecord
  # associations
  has_many :dentist_appointments, class_name: 'Appointment', foreign_key: 'dentist_id', dependent: :destroy
  has_many :patient_appointments, class_name: 'Appointment', foreign_key: 'patient_id', dependent: :destroy

  # validations
  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true
end
