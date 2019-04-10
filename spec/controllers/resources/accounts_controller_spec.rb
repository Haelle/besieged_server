require 'rails_helper'

RSpec.describe Resources::AccountsController, type: :controller do
  it_behaves_like 'unauthorized', :get, :index
  it_behaves_like 'unauthorized', :get, :show, id: 1
  it_behaves_like 'unauthorized', :put, :update, id: 1
  it_behaves_like 'unauthorized', :delete, :destroy, id: 1

  let(:valid_attributes) { attributes_for :account }
  let(:invalid_attributes) { attributes_for :invalid_account }
  let!(:account) { create :account }

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
      get :show, params: { id: account.to_param }

      expect(response).to be_successful
      expect(response_json).to include email: account.email
    end
  end

  describe 'POST #create' do
    before do
      request.headers[JWTSessions.access_header] = nil
    end

    context 'with valid params' do
      it 'creates a new Account' do
        expect do
          post :create, params: { account: valid_attributes }
        end.to change(Account, :count).by(1)
      end

      it 'creates a non admin Account' do
        post :create, params: { account: valid_attributes }
        new_account = Account.find response_json[:id]

        expect(new_account).to have_attributes admin: false
        expect(response_json).to include email: new_account.email
      end

      it 'renders a JSON response with the new account' do
        post :create, params: { account: valid_attributes }
        new_account = Account.find response_json[:id]

        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(account_url(new_account))
        expect(response.body).not_to include 'password'
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new account' do
        post :create, params: { account: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
        expect(response.body).to match(/email.+is invalid/)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { email: 'new@email.com', current_password: 'password', password: 'still valid' }
      end

      it 'updates the requested account' do
        put :update, params: { id: account.to_param, account: new_attributes }
        account.reload

        expect(response).to have_http_status :ok
        expect(account).to have_attributes email: 'new@email.com'
        expect(account.authenticate('still valid')).to be_truthy
        expect(response_json).to include email: 'new@email.com'
      end

      it 'renders a JSON response with the account' do
        put :update, params: {
          id: account.to_param,
          account: valid_attributes.merge(current_password: 'password')
        }

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
        expect(response.body).not_to include 'password'
        expect(response_json).to include email: valid_attributes[:email]
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the account' do
        put :update, params: { id: account.to_param, account: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
        expect(response.body).to match(/current_password.+can't be blank/)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested account' do
      expect do
        delete :destroy, params: { id: account.to_param }
      end.to change(Account, :count).by(-1)
    end
  end
end
