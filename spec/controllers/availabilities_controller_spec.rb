require 'rails_helper'

describe AvailabilitiesController, type: :controller do
  describe "GET #index" do
    context "when authenticated" do
      let(:patient) { FactoryBot.create(:user) }

      let(:valid_appointment_params) do
        {
          dentist_id: dentist.id,
          from: Date.new(2021, 1, 4),
          to: Date.new(2021, 1, 6)
        }
      end

      before { request.headers['Authorization'] = "Token #{patient.token}" }

      context "when all params are present" do
        let(:dentist) { FactoryBot.create(:user) }
        before do
          # 2021-01-04 appointments
          FactoryBot.create(:appointment, dentist: dentist, day: Date.new(2021, 1, 4), slot: 2)
          FactoryBot.create(:appointment, dentist: dentist, day: Date.new(2021, 1, 4), slot: 3)
          FactoryBot.create(:appointment, dentist: dentist, day: Date.new(2021, 1, 4), slot: 4)
          FactoryBot.create(:appointment, dentist: dentist, day: Date.new(2021, 1, 4), slot: 6)
          # 2021-01-05 appointments
          FactoryBot.create(:appointment, dentist: dentist, day: Date.new(2021, 1, 5), slot: 1)
          FactoryBot.create(:appointment, dentist: dentist, day: Date.new(2021, 1, 5), slot: 11)
          FactoryBot.create(:appointment, dentist: dentist, day: Date.new(2021, 1, 5), slot: 12)
          FactoryBot.create(:appointment, dentist: dentist, day: Date.new(2021, 1, 5), slot: 13)
        end

        it "returns available slots for the specified date range" do
          expected_result = [
            # 2021-01-04
            {"from"=>"2021-01-04T08:00:00", "to"=>"2021-01-04T08:30:00"}, # 1 slot is available
            {"from"=>"2021-01-04T10:00:00", "to"=>"2021-01-04T10:30:00"}, # 5 slot is available
            {"from"=>"2021-01-04T11:00:00", "to"=>"2021-01-04T12:00:00"}, # 7-8 slots are available
            {"from"=>"2021-01-04T13:00:00", "to"=>"2021-01-04T18:00:00"}, # after lunch
            # 2021-01-05
            {"from"=>"2021-01-05T08:30:00", "to"=>"2021-01-05T12:00:00"}, # 2-8 slots are available
            {"from"=>"2021-01-05T14:30:00", "to"=>"2021-01-05T18:00:00"}, # 14-20 slots are available
            # 2021-01-06
            {"from"=>"2021-01-06T08:00:00", "to"=>"2021-01-06T12:00:00"}, # 1-8 slot are available
            {"from"=>"2021-01-06T13:00:00", "to"=>"2021-01-06T18:00:00"}, # 11-20 slot are available
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
