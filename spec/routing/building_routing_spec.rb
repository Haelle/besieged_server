require 'rails_helper'

RSpec.describe BuildingsController, type: :routing do
  describe 'routings' do
    it 'routes to #index' do
      expect(get: 'camps/2/buildings').to route_to('buildings#index', camp_id: '2')
    end

    it 'routes to #show' do
      expect(get: '/buildings/1').to route_to('buildings#show', id: '1')
    end
  end
end
