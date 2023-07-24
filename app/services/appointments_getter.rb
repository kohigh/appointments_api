# frozen_string_literal: true

module AppointmentsGetter
  class AbsentParamsError < StandardError;
    def message
      'Invalid request. You must provide dentist_id along with a date range from and to.'
    end
  end

  def self.call(params)
    raise AbsentParamsError if [params[:dentist_id], params[:from], params[:to]].any?(&:blank?)

    Appointment.where(
      dentist_id: params[:dentist_id],
      day: params[:from]..params[:to],
    )
  end
end