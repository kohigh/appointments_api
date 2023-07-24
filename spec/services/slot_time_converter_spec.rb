# frozen_string_literal: true

require 'rails_helper'

describe SlotTimeConverter do
  context "when days have no slots" do
    let(:free_slots_by_day) do
      {
        "2021-01-04" => [],
        "2021-01-05" => []
      }
    end

    it "returns an empty array" do
      result = SlotTimeConverter.call(free_slots_by_day)

      expect(result).to eq([])
    end
  end

  context "when days have slots" do
    let(:free_slots_by_day) do
      {
        "2021-01-04" => [2, 4, 9, 10],
        "2021-01-05" => [1, 2, 3, 5, 6, 7, 8, 9, 10, 11],
        "2021-01-06" => [3, 8, 9, 10, 12, 13, 14, 15, 16, 17, 18],
      }
    end

    it "returns the correct time slots for each day combining sequence slots into one" do
      expected_result = [
        # 2021-01-04
        { from: "2021-01-04T08:30:00", to: "2021-01-04T09:00:00" },
        { from: "2021-01-04T09:30:00", to: "2021-01-04T10:00:00" },
        # 2021-01-05
        { from: "2021-01-05T08:00:00", to: "2021-01-05T09:30:00" }, # 1-3 slots
        { from: "2021-01-05T10:00:00", to: "2021-01-05T12:00:00" }, # 5-8 slots
        { from: "2021-01-05T13:00:00", to: "2021-01-05T13:30:00" }, # 11 slot, after lunch
        # 2021-01-06
        { from: "2021-01-06T09:00:00", to: "2021-01-06T09:30:00" }, # 3 slot
        { from: "2021-01-06T11:30:00", to: "2021-01-06T12:00:00" }, # 8 slot
        { from: "2021-01-06T13:30:00", to: "2021-01-06T17:00:00" }, # 12-18 slots
      ]

      result = SlotTimeConverter.call(free_slots_by_day)
      expect(result).to eq(expected_result)
    end
  end
end
