require 'rails_helper'

RSpec.describe SiegeMachinesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/camps/1/siege_machines')
        .to route_to('siege_machines#index', camp_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/camps/1/siege_machines/2')
        .to route_to('siege_machines#show', camp_id: '1', id: '2')
    end

    it 'routes to #arm' do
      expect(post: 'camps/1/siege_machines/2/arm')
        .to route_to('siege_machines#arm', camp_id: '1', id: '2')
    end

    it 'routes to #build' do
      expect(post: 'camps/1/siege_machines/build')
        .to route_to('siege_machines#build', camp_id: '1')
    end
  end
end
