require 'rails_helper'

RSpec.describe CampsController, type: :controller do
  it_behaves_like 'unauthorized', :get, :index
  it_behaves_like 'unauthorized', :get, :show, id: 1
  it_behaves_like 'unauthorized', :post, :join, id: 1

  include_context 'user headers'

  describe 'GET #index' do
    it 'returns asuccess response' do
      create_list :camp, 3, :with_castle, :with_characters, :with_weapons
      get :index

      expect(response).to be_successful
      expect(response_json.size).to eq 3
      expect(response_json).to match_json_schema 'camps'
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      camp = create :camp, :with_castle, :with_characters, :with_weapons
      get :show, params: { id: camp.to_param }

      expect(response).to be_successful
      expect(response_json).to match_json_schema 'camp'
    end

    it 'returns camp not found' do
      get :show, params: { id: 'not found' }

      expect(response).to have_http_status :not_found
      expect(response_json).to include error: 'camp not found'
    end
  end

  describe 'POST #join' do
    let(:camp) { create :camp }
    let(:pseudonym) { 'pseudo' }

    it 'joins the camp' do
      post :join, params: {
        id: camp.id,
        pseudonym: pseudonym
      }

      expect(response).to be_successful
      expect(response_json).to match_json_schema 'character'
      expect(response_json).to include pseudonym: pseudonym
    end

    it 'cannot join the camp' do
      post :join, params: {
        id: 'not a camp id',
        pseudonym: pseudonym
      }

      expect(response).to have_http_status :not_found
    end

    it 'cannot join twice a camp' do
      create :character, account: account_from_headers, camp: camp
      post :join, params: {
        id: camp.id,
        pseudonym: pseudonym
      }

      expect(response).to have_http_status :unprocessable_entity
    end
  end

  describe 'POST #build' do
    let(:camp) { create :camp, :with_castle }
    let(:character) { create :character, camp: camp, account: account_from_headers }

    it 'builds a new weapon' do
      post :build, params: {
        id: camp.id,
        character_id: character.id
      }

      camp.reload
      expect(response).to be_successful
      expect(response_json).to match_json_schema 'build_weapon'
      expect(camp.siege_machines.size).to eq 1
      expect(camp.siege_machines.first.camp_id).to eq camp.id
    end

    it 'cannot build instead of someone else' do
      another_character = create :character, camp: camp
      post :build, params: {
        id: camp.id,
        character_id: another_character.id
      }

      expect(response).to have_http_status :unauthorized
    end

    it 'return camp not found' do
      post :build, params: {
        id: 'not found',
        character_id: character.id
      }

      expect(response).to have_http_status :not_found
      expect(response_json).to include error: 'camp not found'
    end

    it 'returns character not found' do
      post :build, params: {
        id: camp.id,
        character_id: 'not found'
      }

      expect(response).to have_http_status :not_found
      expect(response_json).to include error: 'character not found'
    end

    it 'return unprocessable_entity' do
      allow(Camp::Build)
        .to receive(:call)
        .and_return(trb_result_failure_with(error: 'something wrong'))

      post :build, params: {
        id: camp.id,
        character_id: character.id
      }

      expect(response).to have_http_status :unprocessable_entity
    end
  end
end
