require 'rails_helper'

RSpec.describe LoginController, type: :controller do
  describe '#create' do
    context 'when user exists' do
      before { create :account }

      context 'when password is valid' do
        subject { get :create, params: { email: 'email@example.com', password: 'password' } }

        its(:status) { is_expected.to eq 200 }

        it 'has expected JSON keys' do
          subject
          expect(response_json.keys.sort).to eq %i[access access_expires_at csrf refresh refresh_expires_at]
        end
      end

      it 'has 401 response code when password is invalid' do
        get :create, params: { email: 'email@example.com', password: 'invalid password' }
        expect(response).to have_http_status :unauthorized
      end
    end

    pending 'has 404 response code when user does not exists' do
      get :create, params: { email: 'not existing', password: 'useless' }
      expect(response).to have_http_status :not_found
    end
  end
end
