require 'rails_helper'

RSpec.describe "Castles", type: :request do
  describe "GET /castles" do
    it "works! (now write some real specs)" do
      get castles_path, headers: valid_headers
      expect(response).to have_http_status(200)
    end
  end
end
