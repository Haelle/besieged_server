require 'rails_helper'

RSpec.describe LoginController, type: :routing do
  it 'routes to #login_with_email' do
    expect(post: '/login_with_email').to route_to('login#login_with_email')
  end

  it 'routes to #login' do
    expect(post: '/login').to route_to('login#login_with_id')
  end
end
