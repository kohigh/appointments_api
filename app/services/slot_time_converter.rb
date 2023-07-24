# frozen_string_literal: true

module SlotTimeConverter
  MIN_SLOT = 1
  MAX_SLOT = 18
  SLOTS = {
    MIN_SLOT => { from: "T08:00:00", to: "T08:30:00" },
    2 => { from: "T08:30:00", to: "T09:00:00" },
    3 => { from: "T09:00:00", to: "T09:30:00" },
    4 => { from: "T09:30:00", to: "T10:00:00" },
    5 => { from: "T10:00:00", to: "T10:30:00" },
    6 => { from: "T10:30:00", to: "T11:00:00" },
    7 => { from: "T11:00:00", to: "T11:30:00" },
    8 => { from: "T11:30:00", to: "T12:00:00" },
    9 => { from: "T13:00:00", to: "T13:30:00" },
    10 => { from: "T13:30:00", to: "T14:00:00" },
    11 => { from: "T14:00:00", to: "T14:30:00" },
    12 => { from: "T14:30:00", to: "T15:00:00" },
    13 => { from: "T15:00:00", to: "T15:30:00" },
    14 => { from: "T15:30:00", to: "T16:00:00" },
    15 => { from: "T16:00:00", to: "T16:30:00" },
    16 => { from: "T16:30:00", to: "T17:00:00" },
    17 => { from: "T17:00:00", to: "T17:30:00" },
    MAX_SLOT => { from: "T17:30:00", to: "T18:00:00" }
  }
  ALL_SLOTS = SLOTS.keys

  def self.call(free_slots_by_day)
    result = []

    free_slots_by_day.each do |date, free_slots|
      free_slots.each do |slot_number|
        slot_time_info = SLOTS[slot_number]

        slot_start_time = "#{date}#{slot_time_info[:from]}"
        slot_end_time = "#{date}#{slot_time_info[:to]}"

        result << {
          from: slot_start_time,
          to: slot_end_time
        }
      end
    end

    result
  end
end