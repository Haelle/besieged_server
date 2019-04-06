require 'rails_helper'

RSpec.describe RefreshController, type: :controller do
  let(:password) { 'password123' }
  let!(:account) { create(:account) }

  describe 'POST #create' do
    EXPECTED_KEYS = %i[access access_expires_at csrf].freeze

    context 'success' do
      let(:refresh_token) { "Bearer #{valid_refresh}" }

      it 'refresh with valid jwt' do
        request.headers[JWTSessions.refresh_header] = refresh_token
        post :create
        expect(response).to have_http_status :ok
        expect(response_json.keys.sort).to eq EXPECTED_KEYS
      end

      it 'refesh with valid jwt in header downcased' do
        request.headers[JWTSessions.refresh_header.downcase] = refresh_token
        post :create
        expect(response).to have_http_status :ok
        expect(response_json.keys.sort).to eq EXPECTED_KEYS
      end
    end

    context 'failure' do
      it 'jwt is absent' do
        post :create
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
