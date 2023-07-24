# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AppointmentsController, type: :controller do
  describe 'POST #create' do
    let(:dentist) { FactoryBot.create(:user) }

    context 'when authenticated with correct token' do
      let(:patient) { FactoryBot.create(:user) }

      before { request.headers['Authorization'] = "Token #{token}" }

      context 'when making request as a patient' do
        let(:token) { patient.token }

        let(:valid_params) do
          {
            appointment: {
              dentist_id: dentist.id,
              day: '2023-07-21',
              slot: 10
            }
          }
        end

        it 'creates a new appointment' do
          expect {
            post :create, params: valid_params
          }.to change(Appointment, :count).by(1)

          expect(response).to have_http_status(:created)
        end
      end

      context 'when making request as a dentist' do
        let(:token) { dentist.token }

        let(:valid_params) do
          {
            appointment: {
              patient_id: patient.id,
              day: '2023-07-21',
              slot: 10
            }
          }
        end

        it 'creates a new appointment' do
          expect {
            post :create, params: valid_params
          }.to change(Appointment, :count).by(1)

          expect(response).to have_http_status(:created)
        end
      end

      context 'when invalid params are passed' do
        let(:token) { patient.token }

        let(:invalid_params) do
          {
            appointment: {
              dentist_id: nil,
              patient_id: nil,
              day: nil,
              slot: nil
            }
          }
        end

        it 'returns unprocessable_entity status' do
          expect {
            post :create, params: invalid_params
          }.not_to change(Appointment, :count)

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when tries to authenticate with incorrect token' do
      before { request.headers['Authorization'] = "Token asd" }

      let(:patient) { FactoryBot.create(:user) }

      let(:valid_params) do
        {
          appointment: {
            dentist_id: dentist.id,
            patient_id: patient.id,
            day: '2023-07-21',
            slot: 10
          }
        }
      end

      it 'returns not_found' do
        expect {
          post :create, params: valid_params
        }.not_to change(Appointment, :count)

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when not authenticated' do
      let(:patient) { FactoryBot.create(:user) }

      let(:valid_params) do
        {
          appointment: {
            dentist_id: dentist.id,
            patient_id: patient.id,
            day: '2023-07-21',
            slot: 10
          }
        }
      end

      it 'returns unauthorized' do
        expect {
          post :create, params: valid_params
        }.not_to change(Appointment, :count)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
