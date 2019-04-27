require 'rails_helper'

RSpec.describe Resources::CastlesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/resources/castles').to route_to('resources/castles#index')
    end

    it 'routes to #show' do
      expect(get: '/resources/castles/1').to route_to('resources/castles#show', id: '1')
    end
  end
end
