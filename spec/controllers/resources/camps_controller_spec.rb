require 'rails_helper'

RSpec.describe Resources::CampsController, type: :controller do
  it_behaves_like 'unauthorized', :get, :index
  it_behaves_like 'unauthorized', :get, :show, id: 1

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
      camp = create :camp
      get :show, params: { id: camp.to_param }

      expect(response).to be_successful
      # not data in this object
    end
  end
end
