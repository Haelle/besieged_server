require 'rails_helper'

RSpec.describe "Characters", type: :request do
  describe "GET /characters" do
    it "works! (now write some real specs)" do
      headers = {
        "#{JWTSessions.access_header}": valid_access
      }
      get characters_path, headers: headers
      expect(response).to have_http_status(200)
    end
  end
end
