require 'rails_helper'

RSpec.describe Resources::CharactersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/resources/characters').to route_to('resources/characters#index')
    end

    it 'routes to #show' do
      expect(get: '/resources/characters/1').to route_to('resources/characters#show', id: '1')
    end
  end
end
