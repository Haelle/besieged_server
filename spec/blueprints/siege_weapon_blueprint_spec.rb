require 'rails_helper'

RSpec.describe SiegeWeaponBlueprint do
  it 'renders one weapon' do
    json = described_class.render(create :siege_weapon)
    expect(json).to match_json_schema 'siege_weapon'
  end

  it 'renders many weapons' do
    json = described_class.render(create_list :siege_weapon, 5)
    expect(json).to match_json_schema 'siege_weapons'
  end
end
