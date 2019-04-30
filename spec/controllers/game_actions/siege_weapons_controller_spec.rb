require 'rails_helper'

RSpec.describe GameActions::SiegeWeaponsController, type: :controller do
  it_behaves_like 'unauthorized', :post, :arm, siege_weapon_id: 1

  include_context 'user headers'

  describe 'POST #arm' do
    include_context 'basic game'

    it 'arms the weapon' do
      post :arm, params: {
        siege_weapon_id: siege_weapon.id,
        character_id: character.id
      }

      castle.reload
      expect(response).to be_successful
      expect(response_json).to include damages: siege_weapon.damages
      expect(castle.health_points).to eq 499
    end

    it 'cannot arm a weapon from another camp' do
      other_camp_siege_weapon = create :siege_weapon
      post :arm, params: {
        siege_weapon_id: other_camp_siege_weapon.id,
        character_id: character.id
      }

      expect(response).to have_http_status :unprocessable_entity
      expect(response_json).to include error: "character (#{character.id}) does not belongs to the camp (#{other_camp_siege_weapon.camp.id}) of this weapon (#{other_camp_siege_weapon.id})"
      expect(castle.health_points).to eq 500
    end

    it 'cannot arm with someone\'s else character' do
      another_character = create :character
      post :arm, params: {
        siege_weapon_id: siege_weapon.id,
        character_id: another_character.id
      }

      expect(response).to have_http_status :unauthorized
    end
  end
end
