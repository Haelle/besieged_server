require 'rails_helper'

RSpec.describe SiegeWeapon::Build do
  subject { described_class.call camp: camp, character: character }

  context 'when building went fine' do
    include_context 'basic game'

    it { is_expected.to be_success }

    it 'builds a new weapon' do
      expect { subject }.to change(camp.siege_weapons, :count).by 1
    end

    it 'returns the new weapon' do
      new_weapon = camp.siege_weapons.find_by id: subject[:siege_weapon].id
      expect(new_weapon).to be_persisted
    end

    it 'build a new weapon with a random name' do
      new_weapon = camp.siege_weapons.find_by id: subject[:siege_weapon].id
      expect(new_weapon.name).to be_a String
      expect(new_weapon.name.size).to be > 5
    end

    its([:camp]) { is_expected.to eq camp }
    its([:status]) { is_expected.to eq 'built' }
  end

  context 'when user does not belongs to this camp' do
    let(:camp) { create :camp }
    let(:character) { create :character, account: account_from_headers }

    it { is_expected.to be_failure }

    it 'does not build the weapon' do
      expect { subject }.not_to change(camp.siege_weapons, :count)
    end

    its([:error]) { is_expected.to eq "character (#{character.id}) does not belong to the camp (#{camp.id})" }
  end
end
