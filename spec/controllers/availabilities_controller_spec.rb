require 'rails_helper'

describe AvailabilitiesController, type: :controller do
  describe "GET #index" do
    context "when authenticated" do
      let(:patient) { FactoryBot.create(:user) }

      let(:valid_appointment_params) do
        {
          dentist_id: dentist.id,
          from: Date.new(2021, 1, 4),
          to: Date.new(2021, 1, 5)
        }
      end

      before { request.headers['Authorization'] = "Token #{patient.token}" }

      context "when all params are present" do
        let(:dentist) { FactoryBot.create(:user) }
        before do
          FactoryBot.create(:appointment, dentist: dentist, day: Date.new(2021, 1, 4), slot: 2)
          FactoryBot.create(:appointment, dentist: dentist, day: Date.new(2021, 1, 4), slot: 4)
          FactoryBot.create(:appointment, dentist: dentist, day: Date.new(2021, 1, 5), slot: 1)
        end

        it "returns available slots for the specified date range" do
          expected_result = [
            # 2021-01-04
            {"from"=>"2021-01-04T08:00:00", "to"=>"2021-01-04T08:30:00"},
            {"from"=>"2021-01-04T09:00:00", "to"=>"2021-01-04T09:30:00"},
            {"from"=>"2021-01-04T10:00:00", "to"=>"2021-01-04T10:30:00"},
            {"from"=>"2021-01-04T10:30:00", "to"=>"2021-01-04T11:00:00"},
            {"from"=>"2021-01-04T11:00:00", "to"=>"2021-01-04T11:30:00"},
            {"from"=>"2021-01-04T11:30:00", "to"=>"2021-01-04T12:00:00"},
            {"from"=>"2021-01-04T13:00:00", "to"=>"2021-01-04T13:30:00"},
            {"from"=>"2021-01-04T13:30:00", "to"=>"2021-01-04T14:00:00"},
            {"from"=>"2021-01-04T14:00:00", "to"=>"2021-01-04T14:30:00"},
            {"from"=>"2021-01-04T14:30:00", "to"=>"2021-01-04T15:00:00"},
            {"from"=>"2021-01-04T15:00:00", "to"=>"2021-01-04T15:30:00"},
            {"from"=>"2021-01-04T15:30:00", "to"=>"2021-01-04T16:00:00"},
            {"from"=>"2021-01-04T16:00:00", "to"=>"2021-01-04T16:30:00"},
            {"from"=>"2021-01-04T16:30:00", "to"=>"2021-01-04T17:00:00"},
            {"from"=>"2021-01-04T17:00:00", "to"=>"2021-01-04T17:30:00"},
            {"from"=>"2021-01-04T17:30:00", "to"=>"2021-01-04T18:00:00"},
            # 2021-01-05
            {"from"=>"2021-01-05T08:30:00", "to"=>"2021-01-05T09:00:00"},
            {"from"=>"2021-01-05T09:00:00", "to"=>"2021-01-05T09:30:00"},
            {"from"=>"2021-01-05T09:30:00", "to"=>"2021-01-05T10:00:00"},
            {"from"=>"2021-01-05T10:00:00", "to"=>"2021-01-05T10:30:00"},
            {"from"=>"2021-01-05T10:30:00", "to"=>"2021-01-05T11:00:00"},
            {"from"=>"2021-01-05T11:00:00", "to"=>"2021-01-05T11:30:00"},
            {"from"=>"2021-01-05T11:30:00", "to"=>"2021-01-05T12:00:00"},
            {"from"=>"2021-01-05T13:00:00", "to"=>"2021-01-05T13:30:00"},
            {"from"=>"2021-01-05T13:30:00", "to"=>"2021-01-05T14:00:00"},
            {"from"=>"2021-01-05T14:00:00", "to"=>"2021-01-05T14:30:00"},
            {"from"=>"2021-01-05T14:30:00", "to"=>"2021-01-05T15:00:00"},
            {"from"=>"2021-01-05T15:00:00", "to"=>"2021-01-05T15:30:00"},
            {"from"=>"2021-01-05T15:30:00", "to"=>"2021-01-05T16:00:00"},
            {"from"=>"2021-01-05T16:00:00", "to"=>"2021-01-05T16:30:00"},
            {"from"=>"2021-01-05T16:30:00", "to"=>"2021-01-05T17:00:00"},
            {"from"=>"2021-01-05T17:00:00", "to"=>"2021-01-05T17:30:00"},
            {"from"=>"2021-01-05T17:30:00", "to"=>"2021-01-05T18:00:00"}
          ]

          get :index, params: valid_appointment_params

          expect(response).to have_http_status(:ok)

          expect(JSON.parse(response.body)).to eq(expected_result)
        end
      end

      context "when any of the params is missing" do
        let(:dentist) { OpenStruct.new(id: 999) }

        it "returns unprocessable_entity status and error message" do
          get :index, params: valid_appointment_params.except(:dentist_id)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to eq({ "errors" => ["Invalid request. You must provide dentist_id along with a date range from and to."] })
        end

        it "returns unprocessable_entity status and error message" do
          get :index, params: valid_appointment_params.except(:from)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to eq({ "errors" => ["Invalid request. You must provide dentist_id along with a date range from and to."] })
        end

        it "returns unprocessable_entity status and error message" do
          get :index, params: valid_appointment_params.except(:to)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to eq({ "errors" => ["Invalid request. You must provide dentist_id along with a date range from and to."] })
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
end
