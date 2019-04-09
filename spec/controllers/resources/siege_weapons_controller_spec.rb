require 'rails_helper'

RSpec.describe Resources::SiegeWeaponsController, type: :controller do
  it_behaves_like 'unauthorized resource'

  let(:valid_attributes) { attributes_for :siege_weapon, camp_id: camp.id }
  let(:invalid_attributes) { attributes_for :invalid_siege_weapon }
  let(:siege_weapon) { create :siege_weapon }
  let(:camp) { create :camp }

  before do
    siege_weapon
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
      get :show, params: { id: siege_weapon.to_param }

      expect(response).to be_successful
      expect(response_json).to include damage: 1
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new SiegeWeapon' do
        expect {
          post :create, params: { siege_weapon: valid_attributes }
        }.to change(SiegeWeapon, :count).by(1)
      end

      it 'renders a JSON response with the new siege_weapon' do
        post :create, params: { siege_weapon: valid_attributes }
        new_weapon = SiegeWeapon.find response_json[:id]

        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(siege_weapon_url(new_weapon))
        expect(response_json).to include damage: 1
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new siege_weapon' do
        post :create, params: { siege_weapon: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
        expect(response_json).to include damage: ["can't be blank"]
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { damage: 10 } }

      it 'updates the requested siege_weapon' do
        put :update, params: { id: siege_weapon.to_param, siege_weapon: new_attributes }
        siege_weapon.reload

        expect(siege_weapon).to have_attributes damage: 10
        expect(response).to have_http_status(:ok)
        expect(response_json).to include damage: 10
      end

      it 'renders a JSON response with the siege_weapon' do
        put :update, params: { id: siege_weapon.to_param, siege_weapon: valid_attributes }

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
        expect(response_json).to include damage: 1
        expect(siege_weapon).to have_attributes damage: 1
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the siege_weapon' do
        put :update, params: { id: siege_weapon.to_param, siege_weapon: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
        expect(response_json).to include damage: ["can't be blank"]
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested siege_weapon' do
      expect {
        delete :destroy, params: { id: siege_weapon.to_param }
      }.to change(SiegeWeapon, :count).by(-1)
    end
  end
end
