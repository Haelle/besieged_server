require 'rails_helper'

RSpec.describe Resources::SiegeWeaponsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/resources/siege_weapons').to route_to('resources/siege_weapons#index')
    end

    it 'routes to #show' do
      expect(get: '/resources/siege_weapons/1').to route_to('resources/siege_weapons#show', id: '1')
    end
  end
end
