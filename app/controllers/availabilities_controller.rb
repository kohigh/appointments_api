# frozen_string_literal: true

class AvailabilitiesController < BaseController
  def index
    begin
      @appointments = AppointmentsGetter.call(params)
    rescue AppointmentsGetter::AbsentParamsError => e
      return render json: { errors: [e.message] }, status: :unprocessable_entity
    end

    slots = AvailableSlotsGetter.call(@appointments)

    render json: SlotTimeConverter.call(slots)
  end
end
