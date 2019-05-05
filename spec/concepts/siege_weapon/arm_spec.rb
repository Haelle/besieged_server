require 'rails_helper'

RSpec.describe SiegeWeapon::Arm do
  subject { described_class.call siege_weapon: siege_weapon, character: character }

  context 'when arming went fine' do
    include_context 'basic game'

    it { is_expected.to be_success }

    it 'damages the castle' do
      expect { subject }.to change(castle, :health_points).by(-siege_weapon.damages)
    end

    its([:siege_weapon]) { is_expected.to eq siege_weapon }
    its([:castle]) { is_expected.to eq siege_weapon.camp.castle }

    it 'returns an updated castle' do
      updated_castle = subject[:castle]
      expect(updated_castle).to have_attributes health_points: 499
    end
  end

  context 'when castle is destroyed' do
    include_context 'basic game'

    before do
      castle.update health_points: 10
      siege_weapon.update damages: 100
    end

    it { is_expected.to be_success }

    it 'change health points to 0' do
      expect(subject[:castle].health_points).to eq 0
    end
  end

  context 'when user does not belongs to same camp as the weapon' do
    let!(:camp) { create :camp }
    let!(:castle) { create :castle, camp: camp }
    let!(:siege_weapon) { create :siege_weapon, camp: camp }

    let(:another_camp) { create :camp }
    let(:character) { create :character, camp: another_camp }

    it { is_expected.to be_failure }

    it 'does not damage the castle' do
      expect { subject }.not_to change(castle, :health_points)
    end

    its([:error]) { is_expected.to eq "character (#{character.id}) does not belong to the camp (#{camp.id}) of this weapon (#{siege_weapon.id})" }
  end
end
