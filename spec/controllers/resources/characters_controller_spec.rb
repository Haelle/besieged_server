require 'rails_helper'

RSpec.describe Resources::CharactersController, type: :controller do
  it_behaves_like 'unauthorized resource'

  let(:valid_attributes) { attributes_for :character, camp_id: camp.id }
  let(:invalid_attributes) { attributes_for :invalid_character }
  let(:character) { create :character }
  let(:camp) { create :camp }

  before do
    character
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
      get :show, params: { id: character.to_param }

      expect(response).to be_successful
      expect(response_json).to include pseudonyme: 'Kevin'
    end
  end

  context 'POST #create' do
    context 'with valid params' do
      it 'creates a new Character' do
        expect {
          post :create, params: { character: valid_attributes }
        }.to change(Character, :count).by(1)
      end

      it 'renders a JSON response with the new character' do
        post :create, params: { character: valid_attributes }
        new_character = Character.find response_json[:id]

        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(character_url(new_character))
        expect(response_json).to include pseudonyme: 'Kevin', camp_id: camp.id
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new character' do
        post :create, params: { character: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
        expect(response_json).to include pseudonyme: ["can't be blank"]
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { pseudonyme: 'new pseudonyme' } }

      it 'updates the requested character' do
        put :update, params: { id: character.to_param, character: new_attributes }
        character.reload

        expect(character).to have_attributes pseudonyme: 'new pseudonyme'
        expect(response).to have_http_status(:ok)
        expect(response_json).to include pseudonyme: 'new pseudonyme'
      end

      it 'renders a JSON response with the character' do
        put :update, params: { id: character.to_param, character: valid_attributes }

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
        expect(response_json).to include pseudonyme: 'Kevin'
        expect(character).to have_attributes pseudonyme: 'Kevin'
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the character' do
        put :update, params: { id: character.to_param, character: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
        expect(response_json).to include pseudonyme: ["can't be blank"]
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested character' do
      expect {
        delete :destroy, params: { id: character.to_param }
      }.to change(Character, :count).by(-1)
    end
  end
end
