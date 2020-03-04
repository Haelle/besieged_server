RSpec.shared_examples 'unauthorized' do |verb, action, params = nil|
  include_context 'empty headers'

  it "returns unauthorized #{verb.upcase}: #{action}" do
    send verb, action, params: params
    expect(response).to have_http_status :unauthorized
  end
end
