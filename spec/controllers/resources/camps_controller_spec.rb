require 'rails_helper'

RSpec.describe Resources::CampsController, type: :controller do
  it_behaves_like 'unauthorized', :get, :index
  it_behaves_like 'unauthorized', :get, :show, id: 1

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
  end
end
