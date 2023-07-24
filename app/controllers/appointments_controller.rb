# frozen_string_literal: true

class AppointmentsController < BaseController
  def index
    begin
      @appointments = AppointmentsGetter.call(params)
    rescue AppointmentsGetter::AbsentParamsError => e
      return render json: { errors: [e.message] }, status: :unprocessable_entity
    end

    render json: Panko::ArraySerializer.new(@appointments, each_serializer: AppointmentSerializer).to_json
  end

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
