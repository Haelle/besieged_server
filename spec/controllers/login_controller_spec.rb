require 'rails_helper'

RSpec.describe LoginController, type: :controller do
  let!(:account) { create :account }

  shared_examples 'login successful' do
    its(:status) { is_expected.to eq 200 }

    it 'has expected JSON keys' do
      subject
      expect(response_json.keys.sort)
        .to eq %i[access access_expires_at csrf refresh refresh_expires_at]
    end

    it 'has valid access token' do
      subject
      access_token = response_json[:access]
      decoded_token = JWTSessions::Token.decode(access_token).first
      expect(decoded_token['account_id']).to eq account.id
    end

    it 'has valid refresh token' do
      subject
      access_token = response_json[:refresh]
      decoded_token = JWTSessions::Token.decode(access_token).first
      expect(decoded_token['account_id']).to eq account.id
    end
  end

  describe '#login_with_email' do
    context 'when account exists' do
      context 'when password is valid' do
        subject { post :login_with_email, params: { email: account.email, password: 'password' } }

        it_behaves_like 'login successful'
      end

      it 'has 401 response code when password is invalid' do
        post :login_with_email, params: { email: account.email, password: 'invalid password' }
        expect(response).to have_http_status :unauthorized
        expect(response_json).to include error: 'wrong password'
      end
    end

    it 'has 404 response code when account does not exists' do
      post :login_with_email, params: { email: 'not existing', password: 'useless' }
      expect(response).to have_http_status :not_found
      expect(response_json).to include error: 'account not found'
    end
  end

  describe '#login_with_id' do
    context 'when account exists' do
      context 'when password is valid' do
        subject { post :login_with_id, params: { id: account.id, password: 'password' } }

        it_behaves_like 'login successful'
      end

      it 'has 401 response code when password is invalid' do
        post :login_with_id, params: { id: account.id, password: 'invalid password' }
        expect(response).to have_http_status :unauthorized
        expect(response_json).to include error: 'wrong password'
      end
    end

    it 'has 404 response code when account does not exists' do
      post :login_with_id, params: { id: 'another id', password: 'useless' }
      expect(response).to have_http_status :not_found
      expect(response_json).to include error: 'account not found'
    end
  end
end
