require 'rails_helper'

RSpec.describe GameActions::CampsController, type: :controller do
  it_behaves_like 'unauthorized', :post, :join, camp_id: 1

  include_context 'user headers'

  describe 'POST #join' do
    let(:camp) { create :camp }
    let(:pseudonyme) { 'pseudo' }

    it 'joins the camp' do
      post :join, params: {
        camp_id: camp.id,
        pseudonyme: pseudonyme
      }

      expect(response).to be_successful
      expect(response_json).to match_json_schema 'character'
      expect(response_json).to include pseudonyme: pseudonyme
    end

    it 'cannot join the camp' do
      post :join, params: {
        camp_id: 'random string',
        pseudonyme: pseudonyme
      }

      expect(response).to have_http_status :not_found
    end

    it 'cannot join twice a camp' do
      create :character, account: account_from_headers, camp: camp
      post :join, params: {
        camp_id: camp.id,
        pseudonyme: pseudonyme
      }

      expect(response).to have_http_status :unprocessable_entity
    end
  end
end
