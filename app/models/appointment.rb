# frozen_string_literal: true

class Appointment < ApplicationRecord
  # associations
  belongs_to :dentist, class_name: 'User', foreign_key: 'dentist_id'
  belongs_to :patient, class_name: 'User', foreign_key: 'patient_id'

  # validations
  validates :dentist_id, presence: true
  validates :patient_id, presence: true
  validates :day, presence: true
  validates :slot, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 20 }

  validates :day, uniqueness: { scope: [:dentist_id, :slot] }
end
