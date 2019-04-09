require 'rails_helper'

RSpec.describe Resources::CastlesController, type: :controller do
  it_behaves_like 'unauthorized resource'

  let(:valid_attributes) { attributes_for :castle, camp_id: camp.id }
  let(:invalid_attributes) { attributes_for :invalid_castle }
  let(:castle) { create :castle }
  let(:camp) { create :camp }

  before do
    castle
    request.headers[JWTSessions.access_header] = valid_access
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: {}

      expect(response).to be_successful
      expect(response_json).to be_an Array
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: castle.to_param }

      expect(response).to be_successful
      expect(response_json).to include health_points: 500
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Castle' do
        expect {
          post :create, params: { castle: valid_attributes }
        }.to change(Castle, :count).by(1)
      end

      it 'renders a JSON response with the new castle' do
        post :create, params: { castle: valid_attributes }
        new_castle = Castle.find response_json[:id]

        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(castle_url(new_castle))
        expect(response_json).to include health_points: 500, camp_id: camp.id
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new castle' do
        post :create, params: { castle: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
        expect(response_json).to include health_points: ["can't be blank"]
      end
    end
  end


  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { health_points: 1000 } }

      it 'updates the requested castle' do
        put :update, params: { id: castle.to_param, castle: new_attributes }
        castle.reload

        expect(response).to have_http_status(:ok)
        expect(response_json).to include health_points: 1000
        expect(castle).to have_attributes health_points: 1000
      end

      it 'renders a JSON response with the castle' do
        put :update, params: { id: castle.to_param, castle: valid_attributes }

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
        expect(response_json).to include health_points: 500
        expect(castle).to have_attributes health_points: 500
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the castle' do
        put :update, params: { id: castle.to_param, castle: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
        expect(response_json).to include health_points: ["can't be blank"]
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested castle' do
      expect {
        delete :destroy, params: { id: castle.to_param }
      }.to change(Castle, :count).by(-1)
    end
  end
end
