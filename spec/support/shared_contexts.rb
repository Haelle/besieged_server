RSpec.shared_context 'user headers' do
  before do
    request.headers[JWTSessions.access_header] = valid_access
  end
end

RSpec.shared_context 'empty headers' do
  before do
    request.headers[JWTSessions.access_header] = nil
  end
end

RSpec.shared_context 'basic game' do
  let!(:camp) { create :camp }
  let!(:castle) { create :castle, camp: camp }
  let!(:character) { create :character, camp: camp }
  let!(:siege_weapon) { create :siege_weapon, camp: camp }
end
