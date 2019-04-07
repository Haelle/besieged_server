require 'rails_helper'

RSpec.describe Resources::CharactersController, type: :controller do
  it_behaves_like 'unauthorized resource'

  let(:valid_attributes) { attributes_for :character }

  let(:invalid_attributes) { attributes_for :invalid_character }

  context 'with access token' do
    before do
      request.headers[JWTSessions.access_header] = valid_access
    end

    describe 'GET #index' do
      it 'returns a success response' do
        Character.create! valid_attributes
        get :index, params: {}
        expect(response).to be_successful
      end
    end

    describe 'GET #show' do
      it 'returns a success response' do
        character = Character.create! valid_attributes
        get :show, params: { id: character.to_param }
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Character' do
          expect do
            post :create, params: { character: valid_attributes }
          end.to change(Character, :count).by(1)
        end

        it 'renders a JSON response with the new character' do
          post :create, params: { character: valid_attributes }
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(character_url(Character.last))
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
          character = Character.create! valid_attributes
          put :update, params: { id: character.to_param, character: new_attributes }
          character.reload
          expect(character).to have_attributes pseudonyme: 'new pseudonyme'
        end

        it 'renders a JSON response with the character' do
          character = Character.create! valid_attributes

          put :update, params: { id: character.to_param, character: valid_attributes }
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end
      end

      context 'with invalid params' do
        it 'renders a JSON response with errors for the character' do
          character = Character.create! valid_attributes

          put :update, params: { id: character.to_param, character: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested character' do
        character = Character.create! valid_attributes
        expect do
          delete :destroy, params: { id: character.to_param }
        end.to change(Character, :count).by(-1)
      end
    end
  end
end
