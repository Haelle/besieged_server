require 'rails_helper'

RSpec.describe LoginController, type: :routing do
  it 'routes to #login' do
    expect(:post => '/login').to route_to('login#create')
  end
end
