require 'rails_helper'

RSpec.describe 'Camps', type: :request do
  describe 'GET /camps' do
    it 'works! (now write some real specs)' do
      get camps_path, headers: valid_headers
      expect(response).to have_http_status(200)
    end
  end
end
