# frozen_string_literal: true

class AppointmentsController < BaseController
  def create
    @appointment = Appointment.new(appointment_params)

    if appointment_params[:dentist_id].blank?
      @appointment.dentist = current_user # todo: verify that current_user has the role of a dentist
    else
      @appointment.patient = current_user # todo: verify that current_user has the role of a patient
    end

    if @appointment.save
      head :created
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:dentist_id, :patient_id, :day, :slot)
  end
end
