require 'rails_helper'

RSpec.describe CampsController, type: :controller do
  it_behaves_like 'unauthorized', :get, :index
  it_behaves_like 'unauthorized', :get, :show, id: 1
  it_behaves_like 'unauthorized', :post, :join, id: 1
  it_behaves_like 'not found', :get, :show

  include_context 'user headers'

  describe 'GET #index' do
    it 'returns asuccess response' do
      create_list :camp, 3, :with_characters, :with_siege_machines
      get :index

      expect(response).to be_successful
      expect(response_json.size).to eq 3
      expect(response_json).to match_json_schema 'camps'
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      camp = create :camp, :with_characters, :with_siege_machines
      get :show, params: { id: camp.to_param }

      expect(response).to be_successful
      expect(response_json).to match_json_schema 'camp'
    end
  end

  describe 'POST #join' do
    let(:camp) { create :camp }
    let(:pseudonym) { 'pseudo' }

    it 'joins the camp' do
      post :join, params: {
        id: camp.id,
        pseudonym: pseudonym
      }

      expect(response).to be_successful
      expect(response_json).to match_json_schema 'character'
      expect(response_json).to include pseudonym: pseudonym
    end

    it 'cannot join the camp' do
      post :join, params: {
        id: 'not a camp id',
        pseudonym: pseudonym
      }

      expect(response).to have_http_status :not_found
    end

    it 'cannot join twice a camp' do
      create :character, account: account_from_headers, camp: camp
      post :join, params: {
        id: camp.id,
        pseudonym: pseudonym
      }

      expect(response).to have_http_status :bad_request
    end
  end
end
