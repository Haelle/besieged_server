require 'rails_helper'

RSpec.describe Resources::CampsController, type: :controller do
  it_behaves_like 'unauthorized', :get, :index
  it_behaves_like 'unauthorized', :get, :show, id: 1
  it_behaves_like 'unauthorized', :delete, :destroy, id: 1
  it_behaves_like 'unauthorized', :post, :create, id: 1

  let(:valid_attributes) { attributes_for :camp }

  let(:invalid_attributes) {
    # currently a camp cannot be invalid
    skip('Add a hash of attributes valid for your model')
  }

  let(:camp) { create :camp }

  before do
    camp
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
      get :show, params: { id: camp.to_param }

      expect(response).to be_successful
      # not data in this object
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Camp' do
        expect {
          post :create, params: { camp: valid_attributes }
        }.to change(Camp, :count).by(1)
      end

      it 'renders a JSON response with the new camp' do
        post :create, params: { camp: valid_attributes }
        new_camp = Camp.find response_json[:id]

        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(camp_url(new_camp))
        # not data in this object
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new camp' do
        post :create, params: { camp: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
        # not validation constrain here
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested camp' do
      expect {
        delete :destroy, params: { id: camp.to_param }
      }.to change(Camp, :count).by(-1)
    end
  end
end
