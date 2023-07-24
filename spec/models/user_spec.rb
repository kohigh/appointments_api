# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:dentist_appointments).class_name('Appointment').with_foreign_key('dentist_id').dependent(:destroy) }
    it { should have_many(:patient_appointments).class_name('Appointment').with_foreign_key('patient_id').dependent(:destroy) }
  end

  describe 'validations' do
    # presence
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }

    # uniq
    it { should validate_uniqueness_of(:email) }
  end

  it 'should have a valid factory' do
    expect(FactoryBot.build(:user)).to be_valid
  end
end