require 'rails_helper'

RSpec.describe BuildingsController, type: :controller do
  it_behaves_like 'unauthorized', :get, :index, camp_id: 1
  it_behaves_like 'unauthorized', :get, :show, id: 0
  it_behaves_like 'not found', :get, :show

  include_context 'user headers'

  describe 'GET #index for camp' do
    it 'returns a success response' do
      camp = create :camp, :with_buildings
      get :index, params: { camp_id: camp.id }

      expect(response).to be_successful
      expect(response_json.size).to eq 2
      expect(response_json).to match_json_schema 'buildings'
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      building = create :building
      get :show, params: { id: building.to_param }

      expect(response).to be_successful
      expect(response_json).to match_json_schema 'building'
    end
  end
end
