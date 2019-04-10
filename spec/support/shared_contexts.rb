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
