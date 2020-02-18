require 'rails_helper'

RSpec.describe SiegeMachinesController, type: :controller do
  it_behaves_like 'unauthorized', :get, :index, camp_id: 1
  it_behaves_like 'unauthorized', :get, :show, camp_id: 1, id: 0
  it_behaves_like 'unauthorized', :post, :arm, camp_id: 1, id: 1

  include_context 'user headers'

  describe 'GET #index' do
    it 'returns a success response' do
      camp = create :camp
      create_list :siege_machine, 3, camp: camp
      get :index, params: { camp_id: camp.id }

      expect(response).to be_successful
      expect(response_json.size).to eq 3
      expect(response_json).to match_json_schema 'siege_machines'
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      siege_machine = create :siege_machine
      get :show, params: { camp_id: siege_machine.camp.id, id: siege_machine.to_param }

      expect(response).to be_successful
      expect(response_json).to match_json_schema 'siege_machine'
    end

    it 'returns a weapon not found' do
      camp = create :camp
      get :show, params: { camp_id: camp.id, id: 'not found' }

      expect(response).to have_http_status :not_found
      expect(response_json).to include error: 'siege weapon not found'
    end

    it 'returns a camp not found' do
      siege_machine = create :siege_machine
      get :show, params: { camp_id: 'not found', id: siege_machine.id }

      expect(response).to have_http_status :not_found
      expect(response_json).to include error: 'camp not found'
    end
  end

  describe 'POST #arm' do
    include_context 'basic game'

    it 'arms the weapon' do
      post :arm, params: {
        id: siege_machine.id,
        camp_id: siege_machine.camp.id,
        character_id: character.id
      }

      castle.reload
      expect(response).to be_successful
      expect(response_json).to match_json_schema 'arm_weapon'
      expect(castle.health_points).to eq 499
    end

    it 'returns weapon not found' do
      post :arm, params: {
        id: 'not found',
        camp_id: camp.id,
        character_id: character.id
      }

      expect(response).to have_http_status :not_found
      expect(response_json).to include error: 'siege weapon not found'
    end

    it 'return camp not found' do
      post :arm, params: {
        id: siege_machine.id,
        camp_id: 'not found',
        character_id: character.id
      }

      expect(response).to have_http_status :not_found
      expect(response_json).to include error: 'camp not found'
    end

    it 'returns character not found' do
      post :arm, params: {
        id: siege_machine.id,
        camp_id: camp.id,
        character_id: 'not found'
      }

      expect(response).to have_http_status :not_found
      expect(response_json).to include error: 'character not found'
    end

    it 'returns unprocessable_entity' do
      allow(SiegeMachine::Arm)
        .to receive(:call)
        .and_return(trb_result_failure_with(error: 'something wrong'))

      post :arm, params: {
        id: siege_machine.id,
        camp_id: siege_machine.camp.id,
        character_id: character.id
      }

      expect(response).to have_http_status :unprocessable_entity
    end
  end

  describe 'POST #build' do
    let(:camp) { create :camp, :with_castle }
    let(:character) { create :character, camp: camp, account: account_from_headers }

    it 'builds a new weapon' do
      post :build, params: {
        camp_id: camp.id,
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
        camp_id: camp.id,
        character_id: another_character.id
      }

      expect(response).to have_http_status :unauthorized
    end

    it 'return camp not found' do
      post :build, params: {
        camp_id: 'not found',
        character_id: character.id
      }

      expect(response).to have_http_status :not_found
      expect(response_json).to include error: 'camp not found'
    end

    it 'returns character not found' do
      post :build, params: {
        camp_id: camp.id,
        character_id: 'not found'
      }

      expect(response).to have_http_status :not_found
      expect(response_json).to include error: 'character not found'
    end

    it 'return unprocessable_entity' do
      allow(SiegeMachine::Build)
        .to receive(:call)
        .and_return(trb_result_failure_with(error: 'something wrong'))

      post :build, params: {
        camp_id: camp.id,
        character_id: character.id
      }

      expect(response).to have_http_status :unprocessable_entity
    end
  end
end
