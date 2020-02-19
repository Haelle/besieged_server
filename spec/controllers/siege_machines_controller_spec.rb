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
      get :show, params: { id: siege_machine.to_param }

      expect(response).to be_successful
      expect(response_json).to match_json_schema 'siege_machine'
    end

    it 'returns a weapon not found' do
      get :show, params: { id: 'not found' }

      expect(response).to have_http_status :not_found
      expect(response_json).to include error: 'siege machine not found'
    end
  end

  describe 'POST #arm' do
    include_context 'basic game'

    it 'arms the weapon' do
      post :arm, params: {
        id: siege_machine.id,
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
        character_id: character.id
      }

      expect(response).to have_http_status :not_found
      expect(response_json).to include error: 'siege machine not found'
    end

    it 'returns character not found' do
      post :arm, params: {
        id: siege_machine.id,
        character_id: 'not found'
      }

      expect(response).to have_http_status :not_found
      expect(response_json).to include error: 'character not found'
    end

    it 'returns unprocessable_entity when operation failed' do
      allow(SiegeMachine::Arm)
        .to receive(:call)
        .and_return(trb_result_failure_with(error: 'something wrong'))

      post :arm, params: {
        id: siege_machine.id,
        character_id: character.id
      }

      expect(response).to have_http_status :unprocessable_entity
    end
  end
end
