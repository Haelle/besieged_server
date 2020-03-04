require 'rails_helper'

RSpec.describe CharactersController, type: :controller do
  it_behaves_like 'unauthorized', :get, :index, camp_id: 0
  it_behaves_like 'unauthorized', :get, :index, account_id: 0
  it_behaves_like 'unauthorized', :get, :show, id: 0
  it_behaves_like 'not found', :get, :show
  it_behaves_like 'not found', :get, :index, { camp_id: 'not found' }, Camp

  include_context 'user headers'

  describe 'GET #index_by_camp' do
    it 'returns a success response' do
      camp = create :camp
      get :index, params: { camp_id: camp.id }

      expect(response).to be_successful
      expect(response_json).to match_json_schema 'characters'
    end

    it 'returns only characters belonging to camp' do
      my_camp = create :camp
      my_characters = create_list :character, 2, camp: my_camp
      other_camp = create :camp
      other_characters = create_list :character, 3, camp: other_camp

      get :index, params: { camp_id: my_camp.id }

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

  describe 'GET #index_by_account' do
    it 'returns a success response' do
      get :index, params: { account_id: 1 }

      expect(response).to be_successful
      expect(response_json).to match_json_schema 'characters'
    end

    it 'returns only characters owned by account in headers' do
      other_characters = create_list :character, 3
      my_characters = create_list :character, 2, account: account_from_headers
      get :index, params: { account_id: account_from_headers.id }

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
