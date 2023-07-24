# frozen_string_literal: true

module AvailableSlotsGetter
  def self.call(appointments)
    occupied_slots_by_day = Hash.new { |h, k| h[k] = [] }
    appointments.each { |appointment| occupied_slots_by_day[appointment.day] << appointment.slot }

    available_timeframes = {}

    occupied_slots_by_day.each do |date, occupied_slots|
      available_timeframes[date] = SlotTimeConverter::ALL_SLOTS - occupied_slots
    end

    available_timeframes
  end
end