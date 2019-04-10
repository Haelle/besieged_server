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
      expect(castle.health_points).to eq 499
    end

    it 'is not allowed to arm the weapon' do
      orphan_character = create :character
      post :arm, params: {
        siege_weapon_id: siege_weapon.id,
        character_id: orphan_character.id
      }

      expect(response).to have_http_status :unprocessable_entity
      expect(response_json).to include error: "character (#{orphan_character.id}) does not belongs to the camp (#{siege_weapon.camp.id}) of this weapon (#{siege_weapon.id})"
      expect(castle.health_points).to eq 500
    end
  end
end
