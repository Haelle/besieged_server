RSpec.shared_examples 'unauthorized' do |verb, action, params = nil|
  include_context 'empty headers'

  it 'returns unauthorized' do
    send verb, action, params: params
    expect(response).to have_http_status :unauthorized
  end
end

RSpec.shared_examples 'unauthorized resource' do
  before do
    request.headers[JWTSessions.access_header] = nil
  end

  it 'returns unauthorized for #index' do
    get :index
    expect(response).to have_http_status :unauthorized
  end

  it 'returns unauthorized for #show' do
    get :show, params: { id: 1 }
    expect(response).to have_http_status :unauthorized
  end

  it 'returns unauthorized for #create' do
    post :create, params: { id: 1 }
    expect(response).to have_http_status :unauthorized
  end

  it 'returns unauthorized for #update' do
    put :update, params: { id: 1 }
    expect(response).to have_http_status :unauthorized
  end

  it 'returns unauthorized for #destroy' do
    delete :destroy, params: { id: 1 }
    expect(response).to have_http_status :unauthorized
  end
end
