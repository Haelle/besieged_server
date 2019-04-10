require 'rails_helper'

RSpec.describe Resources::CastlesController, type: :controller do
  it_behaves_like 'unauthorized', :get, :index
  it_behaves_like 'unauthorized', :get, :show, id: 0

  before do
    request.headers[JWTSessions.access_header] = valid_access
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: {}

      expect(response).to be_successful
      expect(response_json).to be_an Array
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      castle = create :castle
      get :show, params: { id: castle.to_param }

      expect(response).to be_successful
      expect(response_json).to include health_points: 500
    end
  end
end
