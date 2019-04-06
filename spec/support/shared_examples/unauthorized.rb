RSpec.shared_examples 'unauthorized' do |verb, action, params = nil|
  it 'returns unauthorized' do
    send verb, action, params: params
    expect(response).to have_http_status :unauthorized
  end
end
