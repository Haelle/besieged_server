require 'rails_helper'

RSpec.describe Resources::SiegeWeaponsController, type: :controller do
  it_behaves_like 'unauthorized', :get, :index
  it_behaves_like 'unauthorized', :get, :show, id: 0

  include_context 'user headers'

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: {}

      expect(response).to be_successful
      expect(response_json).to be_an Array
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      siege_weapon = create :siege_weapon
      get :show, params: { id: siege_weapon.to_param }

      expect(response).to be_successful
      expect(response_json).to include damage: 1
    end
  end
end
