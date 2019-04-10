require 'rails_helper'

RSpec.describe Resources::CampsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/camps').to route_to('resources/camps#index')
    end

    it 'routes to #show' do
      expect(get: '/camps/1').to route_to('resources/camps#show', id: '1')
    end
  end
end
