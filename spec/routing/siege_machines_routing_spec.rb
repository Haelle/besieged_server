require 'rails_helper'

RSpec.describe SiegeMachinesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/camps/1/siege_machines').to route_to('siege_machines#index', camp_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/siege_machines/2').to route_to('siege_machines#show', id: '2')
    end

    it 'routes to #arm' do
      expect(post: '/siege_machines/2/arm').to route_to('siege_machines#arm', id: '2')
    end
  end
end
