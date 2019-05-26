require 'rails_helper'

RSpec.describe SiegeWeaponsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/camps/1/siege_weapons')
        .to route_to('siege_weapons#index', camp_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/camps/1/siege_weapons/2')
        .to route_to('siege_weapons#show', camp_id: '1', id: '2')
    end

    it 'routes to #arm' do
      expect(post: 'camps/1/siege_weapons/2/arm')
        .to route_to('siege_weapons#arm', camp_id: '1', id: '2')
    end

    it 'routes to #build' do
      expect(post: 'camps/1/siege_weapons/build')
        .to route_to('siege_weapons#build', camp_id: '1')
    end
  end
end
