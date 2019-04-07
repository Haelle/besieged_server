require 'rails_helper'

RSpec.describe RefreshController, type: :routing do
  it 'routes to #refresh' do
    expect(post: '/refresh').to route_to('refresh#create')
  end
end
