# frozen_string_literal: true

module SlotTimeConverter
  MIN_SLOT = 1
  MAX_SLOT = 20

  BANNED_SLOTS = [9, 10]

  SLOTS = {
    MIN_SLOT => { from: "T08:00:00", to: "T08:30:00" },
    2 => { from: "T08:30:00", to: "T09:00:00" },
    3 => { from: "T09:00:00", to: "T09:30:00" },
    4 => { from: "T09:30:00", to: "T10:00:00" },
    5 => { from: "T10:00:00", to: "T10:30:00" },
    6 => { from: "T10:30:00", to: "T11:00:00" },
    7 => { from: "T11:00:00", to: "T11:30:00" },
    8 => { from: "T11:30:00", to: "T12:00:00" },
    11 => { from: "T13:00:00", to: "T13:30:00" },
    12 => { from: "T13:30:00", to: "T14:00:00" },
    13 => { from: "T14:00:00", to: "T14:30:00" },
    14 => { from: "T14:30:00", to: "T15:00:00" },
    15 => { from: "T15:00:00", to: "T15:30:00" },
    16 => { from: "T15:30:00", to: "T16:00:00" },
    17 => { from: "T16:00:00", to: "T16:30:00" },
    18 => { from: "T16:30:00", to: "T17:00:00" },
    19 => { from: "T17:00:00", to: "T17:30:00" },
    MAX_SLOT => { from: "T17:30:00", to: "T18:00:00" }
  }

  ALL_SLOTS = SLOTS.keys

  class << self
    def call(free_slots_by_day)
      result = []

      free_slots_by_day.each do |date, free_slots|
        free_slots = free_slots - BANNED_SLOTS

        slots_ranges = find_slots_ranges(free_slots)
        slots_ranges.each do |range|
          slot_start_time = "#{date}#{SLOTS[range.first][:from]}"
          slot_end_time = "#{date}#{SLOTS[range.last][:to]}"

          result << {
            from: slot_start_time,
            to: slot_end_time
          }
        end
      end

      result
    end

    private

    def find_slots_ranges(slots)
      slots.sort.chunk_while { |prev, curr| curr == prev + 1 }.to_a
    end
  end
end