require 'rails_helper'

RSpec.describe SiegeMachinesController, type: :controller do
  it_behaves_like 'unauthorized', :get, :index, camp_id: 1
  it_behaves_like 'unauthorized', :get, :show, camp_id: 1, id: 0
  it_behaves_like 'not found', :get, :show
  it_behaves_like 'not found', :get, :index, { camp_id: 'not found' }, Camp

  include_context 'user headers'

  describe 'GET #index' do
    it 'returns a success response' do
      camp = create :camp, :with_siege_machines
      get :index, params: { camp_id: camp.id }

      expect(response).to be_successful
      expect(response_json.size).to eq 5
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
  end
end
