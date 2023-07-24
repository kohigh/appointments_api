# frozen_string_literal: true

require 'rails_helper'

describe AppointmentsGetter do
  let(:dentist_id) { FactoryBot.create(:user).id }
  let(:from_date) { Date.new(2021, 1, 2) }
  let(:to_date) { Date.new(2021, 1, 6) }

  before do
    FactoryBot.create(:appointment, dentist_id: dentist_id, day: from_date.next_day)
    FactoryBot.create(:appointment, dentist_id: dentist_id, day: to_date.prev_day)
    FactoryBot.create(:appointment, dentist_id: dentist_id, day: to_date.next_day)
    FactoryBot.create(:appointment, day: to_date.prev_day)
  end

  context "when all params are present" do
    it "returns appointments within the specified date range for the given dentist" do
      params = {
        dentist_id: dentist_id,
        from: from_date,
        to: to_date
      }
      result = AppointmentsGetter.call(params)

      expect(result.count).to eq(2)
    end
  end

  context "when any of the params is missing" do
    it "raises AbsentParamsError" do
      params = {
        from: from_date,
        to: to_date
      }
      expect { AppointmentsGetter.call(params) }.to raise_error(AppointmentsGetter::AbsentParamsError)

      params = {
        dentist_id: dentist_id,
        to: to_date
      }
      expect { AppointmentsGetter.call(params) }.to raise_error(AppointmentsGetter::AbsentParamsError)

      params = {
        dentist_id: dentist_id,
        from: from_date
      }
      expect { AppointmentsGetter.call(params) }.to raise_error(AppointmentsGetter::AbsentParamsError)
    end
  end
end
