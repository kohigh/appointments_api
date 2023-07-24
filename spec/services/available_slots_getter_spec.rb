# frozen_string_literal: true

require 'rails_helper'

describe AvailableSlotsGetter do
  context "when empty array passed" do
    it "returns all available slots" do
      result = AvailableSlotsGetter.call([], { from: "2021-01-04", to: "2021-01-05" })
      expect(result).to eq(
                          "2021-01-04" => [1, 2, 3, 4, 5, 6, 7, 8, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20],
                          "2021-01-05" => [1, 2, 3, 4, 5, 6, 7, 8, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20],
                          )
    end
  end

  context "when all slots are occupied" do
    let(:appointments) { SlotTimeConverter::ALL_SLOTS.map { |slot| OpenStruct.new(day: "2021-01-04", slot: slot) } }

    it "returns no slots" do
      expected_result = {
        "2021-01-04" => [],
      }

      result = AvailableSlotsGetter.call(appointments, { from: "2021-01-04", to: "2021-01-04" })
      expect(result).to eq(expected_result)
    end
  end

  context "when some slots are occupied" do
    let(:appointments) do
      [
        OpenStruct.new({ day: "2021-01-04", slot: 2 }),
        OpenStruct.new({ day: "2021-01-05", slot: 1 }),
        OpenStruct.new({ day: "2021-01-05", slot: 6 }),
        OpenStruct.new({ day: "2021-01-06", slot: 10 }),
        OpenStruct.new({ day: "2021-01-06", slot: 15 }),
        OpenStruct.new({ day: "2021-01-06", slot: 18 }),
      ]
    end

    it "returns available slots for each day" do
      expected_result = {
        "2021-01-04" => [1, 3, 4, 5, 6, 7, 8, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20],
        "2021-01-05" => [2, 3, 4, 5, 7, 8, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20],
        "2021-01-06" => [1, 2, 3, 4, 5, 6, 7, 8, 11, 12, 13, 14, 16, 17, 19, 20],
      }

      result = AvailableSlotsGetter.call(appointments, { from: "2021-01-04", to: "2021-01-06" })
      expect(result).to eq(expected_result)
    end
  end
end
