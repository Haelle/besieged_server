RSpec.shared_examples 'not found' do |verb, action, params = { id: 'not found' }, not_found_class = nil|
  include_context 'user headers'

  it "returns not found #{verb.upcase}: #{action}" do
    send verb, action, params: params
    related_class = not_found_class || default_related_class

    expect(response).to have_http_status :not_found
    expect(response_json).to include error: "Couldn't find #{related_class} with 'id'=not found"
  end

  def default_related_class
    described_class
      .name
      .remove('Controller')
      .singularize
  end
end
