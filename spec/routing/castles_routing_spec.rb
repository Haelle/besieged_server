require 'rails_helper'

RSpec.describe CastlesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/castles').to route_to('castles#index')
    end

    it 'routes to #show' do
      expect(get: '/castles/1').to route_to('castles#show', id: '1')
    end
  end
end
