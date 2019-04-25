require 'rails_helper'

RSpec.describe Resources::CastlesController, type: :controller do
  it_behaves_like 'unauthorized', :get, :index
  it_behaves_like 'unauthorized', :get, :show, id: 0

  include_context 'user headers'

  describe 'GET #index' do
    it 'returns a success response' do
      create_list :castle, 3
      get :index

      expect(response).to be_successful
      expect(response_json.size).to eq 3
      expect(response_json).to match_json_schema 'castles'
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      castle = create :castle
      get :show, params: { id: castle.to_param }

      expect(response).to be_successful
      expect(response_json).to match_json_schema 'castle'
    end
  end
end
