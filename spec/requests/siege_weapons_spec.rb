require 'rails_helper'

RSpec.describe "SiegeWeapons", type: :request do
  describe "GET /siege_weapons" do
    it "works! (now write some real specs)" do
      get siege_weapons_path, headers: valid_headers
      expect(response).to have_http_status(200)
    end
  end
end
