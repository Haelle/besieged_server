require 'rails_helper'

RSpec.describe RefreshController, type: :controller do
  describe 'POST #create' do
    EXPECTED_KEYS = %i[access access_expires_at csrf].freeze

    context 'success' do
      let(:refresh_token) { "Bearer #{valid_refresh}" }

      before do
        request.headers[JWTSessions.refresh_header] = refresh_token
        post :create
      end

      it 'refresh with valid jwt' do
        expect(response).to have_http_status :ok
        expect(response_json.keys.sort).to eq EXPECTED_KEYS
      end

      it 'refesh with valid jwt in header downcased' do
        expect(response).to have_http_status :ok
        expect(response_json.keys.sort).to eq EXPECTED_KEYS
      end

      it 'has a valid access token' do
        access_token = response_json[:access]
        decoded_token = JWTSessions::Token.decode(access_token).first
        expect(decoded_token['account_id']).to eq valid_account.id
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
