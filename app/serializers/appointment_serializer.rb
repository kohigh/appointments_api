# frozen_string_literal: true

class AppointmentSerializer < Panko::Serializer
  attributes :day, :from_to, :slot

  def from_to
    SlotTimeConverter::SLOTS[object.slot]
  end
end