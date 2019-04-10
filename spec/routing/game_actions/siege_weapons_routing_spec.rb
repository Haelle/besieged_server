require 'rails_helper'

RSpec.describe GameActions::SiegeWeaponsController, type: :routing do
  describe 'routing' do
    it 'routes to #arm' do
      expect(post: 'game_actions/siege_weapons/1/arm')
        .to route_to('game_actions/siege_weapons#arm', siege_weapon_id: '1')
    end
  end
end
