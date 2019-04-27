require 'rails_helper'

RSpec.describe GameActions::CampsController, type: :routing do
  describe 'routing' do
    it 'routes to #join' do
      expect(post: 'game_actions/camps/1/join')
        .to route_to('game_actions/camps#join', camp_id: '1')
    end
  end
end
