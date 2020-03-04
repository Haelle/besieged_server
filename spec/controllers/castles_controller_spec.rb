require 'rails_helper'

RSpec.describe CastlesController, type: :controller do
  it_behaves_like 'unauthorized', :get, :index
  it_behaves_like 'unauthorized', :get, :show, id: 0
  it_behaves_like 'not found', :get, :show

  include_context 'user headers'

  describe 'GET #index' do
    it 'returns a success response' do
      create_list :castle, 3, camp: Camp.new
      get :index

      expect(response).to be_successful
      expect(response_json.size).to eq 3
      expect(response_json).to match_json_schema 'castles'
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      castle = create :castle, camp: Camp.new
      get :show, params: { id: castle.to_param }

      expect(response).to be_successful
      expect(response_json).to match_json_schema 'castle'
    end
  end
end
