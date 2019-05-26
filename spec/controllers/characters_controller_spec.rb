require 'rails_helper'

RSpec.describe CharactersController, type: :controller do
  it_behaves_like 'unauthorized', :get, :index_by_account, account_id: 0
  it_behaves_like 'unauthorized', :get, :index_by_camp, camp_id: 0
  it_behaves_like 'unauthorized', :get, :show, id: 0
  it_behaves_like 'unauthorized', :post, :join, camp_id: 1

  include_context 'user headers'

  describe 'GET #index_by_camp' do
    it 'returns 404 error' do
      get :index_by_camp, params: { camp_id: 'id not found' }

      expect(response).to have_http_status :not_found
      expect(response_json).to include error: 'camp not found'
    end

    it 'returns a success response' do
      camp = create :camp
      get :index_by_camp, params: { camp_id: camp.id }

      expect(response).to be_successful
      expect(response_json).to match_json_schema 'characters'
    end

    it 'returns only characters belonging to camp' do
      my_camp = create :camp
      my_characters = create_list :character, 2, camp: my_camp
      other_camp = create :camp
      other_characters = create_list :character, 3, camp: other_camp

      get :index_by_camp, params: { camp_id: my_camp.id }

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
      get :index_by_account, params: { account_id: 1 }

      expect(response).to be_successful
      expect(response_json).to match_json_schema 'characters'
    end

    it 'returns only characters owned by account in headers' do
      other_characters = create_list :character, 3
      my_characters = create_list :character, 2, account: account_from_headers
      get :index_by_account, params: { account_id: account_from_headers.id }

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

    it 'returns character not found' do
      get :show, params: { id: 'not found' }

      expect(response).to have_http_status :not_found
      expect(response_json).to include error: 'character not found'
    end
  end

  describe 'POST #join' do
    let(:camp) { create :camp }
    let(:pseudonyme) { 'pseudo' }

    it 'joins the camp' do
      post :join, params: {
        camp_id: camp.id,
        pseudonyme: pseudonyme
      }

      expect(response).to be_successful
      expect(response_json).to match_json_schema 'character'
      expect(response_json).to include pseudonyme: pseudonyme
    end

    it 'cannot join the camp' do
      post :join, params: {
        camp_id: 'random string',
        pseudonyme: pseudonyme
      }

      expect(response).to have_http_status :not_found
    end

    it 'cannot join twice a camp' do
      create :character, account: account_from_headers, camp: camp
      post :join, params: {
        camp_id: camp.id,
        pseudonyme: pseudonyme
      }

      expect(response).to have_http_status :unprocessable_entity
    end
  end
end
