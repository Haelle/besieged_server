require 'rails_helper'

RSpec.describe CharactersController, type: :routing do
  describe 'routing' do
    it 'routes to #index_by_account' do
      expect(get: '/accounts/1/characters').to route_to('characters#index', account_id: '1')
    end

    it 'routes to #index by camp' do
      expect(get: '/camps/1/characters').to route_to('characters#index', camp_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/characters/1').to route_to('characters#show', id: '1')
    end
  end
end
