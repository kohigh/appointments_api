# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AppointmentsController, type: :controller do
  describe 'GET #index' do
    context "when authenticated" do
      let(:patient) { FactoryBot.create(:user) }

      before { request.headers['Authorization'] = "Token #{patient.token}" }

      context 'with valid params' do
        let(:dentist) { FactoryBot.create(:user) }
        let(:expected) do
          [
            {"day"=>"2021-01-04", "slot"=>2, "from_to"=>{"from"=>"T08:30:00", "to"=>"T09:00:00"}},
            {"day"=>"2021-01-04", "slot"=>4, "from_to"=>{"from"=>"T09:30:00", "to"=>"T10:00:00"}},
            {"day"=>"2021-01-05", "slot"=>1, "from_to"=>{"from"=>"T08:00:00", "to"=>"T08:30:00"}}
          ]
        end

        before do
          FactoryBot.create(:appointment, dentist: dentist, day: Date.new(2021, 1, 4), slot: 2)
          FactoryBot.create(:appointment, dentist: dentist, day: Date.new(2021, 1, 4), slot: 4)
          FactoryBot.create(:appointment, dentist: dentist, day: Date.new(2021, 1, 5), slot: 1)
        end

        it 'returns a list of appointments' do
          get :index, params: { dentist_id: dentist.id, from: '2021-01-04', to: '2021-01-06' }

          expect(response).to have_http_status(:success)
          parsed_response = JSON.parse(response.body)

          expect(parsed_response).to match_array(expected)
        end
      end

      context 'with invalid params' do
        it 'returns an error message' do
          get :index, params: { dentist_id: 1 }

          expect(response).to have_http_status(:unprocessable_entity)

          parsed_response = JSON.parse(response.body)
          expect(parsed_response).to eq({ 'errors' => ['Invalid request. You must provide dentist_id along with a date range from and to.'] })
        end
      end
    end

    context "when not authenticated" do
      it 'returns unauthorized' do
        get :index

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

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
