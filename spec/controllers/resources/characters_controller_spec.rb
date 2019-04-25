require 'rails_helper'

RSpec.describe Resources::CharactersController, type: :controller do
  it_behaves_like 'unauthorized', :get, :index
  it_behaves_like 'unauthorized', :get, :show, id: 0

  include_context 'user headers'

  describe 'GET #index' do
    it 'returns a success response' do
      get :index

      expect(response).to be_successful
      expect(response_json).to match_json_schema 'characters'
    end

    it 'returns only characters owned by account in headers' do
      other_characters = create_list :character, 3
      my_characters = create_list :character, 2, account: account_from_headers
      get :index

      expect(response).to be_successful
      expect(response_json).to match_json_schema 'characters'
      expect(response_json)
        .not_to include(a_hash_including(id: other_characters[0].id))
      expect(response_json).to contain_exactly(
        a_hash_including(id: my_characters[0].id),
        a_hash_including(id: my_characters[1].id)
      )
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      character = create :character, account: account_from_headers
      get :show, params: { id: character.to_param }

      expect(response).to be_successful
      expect(response_json).to match_json_schema 'character'
    end

    it 'is not authorized to see the character of someone else' do
      character = create :character
      get :show, params: { id: character.to_param }

      expect(response).to have_http_status :unauthorized
    end
  end
end
