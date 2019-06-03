require 'rails_helper'

RSpec.describe NamesController, type: :controller do
  describe 'GET #generate' do
    it 'returns a random name' do
      get :generate, params: { syllables_count: 4 }
      expect(response).to have_http_status :ok
      expect(response_json).to include name: String
    end

    it 'returns a short name' do
      get :generate, params: { syllables_count: 2 }
      expect(response_json[:name].size).to be <= 5
    end

    it 'returns a long name' do
      get :generate, params: { syllables_count: 5 }
      expect(response_json[:name].size).to be > 6
    end
  end
end
