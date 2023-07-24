require 'rails_helper'

RSpec.describe Appointment, type: :model do
  describe 'validations' do
    # associations
    it { should belong_to(:dentist).class_name('User') }
    it { should belong_to(:patient).class_name('User') }

    # presence
    it { should validate_presence_of(:day) }
    it { should validate_presence_of(:slot) }

    # others
    it { should validate_uniqueness_of(:day).scoped_to([:dentist_id, :slot]) }
    it { should validate_numericality_of(:slot).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(20) }
  end
end
