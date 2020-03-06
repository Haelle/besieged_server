require 'rails_helper'

RSpec.describe CampsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/camps').to route_to('camps#index')
    end

    it 'routes to #show' do
      expect(get: '/camps/1').to route_to('camps#show', id: '1')
    end

    it 'routes to #join' do
      expect(post: '/camps/1/join').to route_to('camps#join', id: '1')
    end
  end
end
