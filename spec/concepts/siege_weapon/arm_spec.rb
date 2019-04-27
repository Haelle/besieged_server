require 'rails_helper'

RSpec.describe SiegeWeapon::Arm do
  subject { described_class.call siege_weapon: siege_weapon, character: character }

  context 'when arming went fine' do
    include_context 'basic game'

    it { is_expected.to be_success }

    it 'damages the castle' do
      expect { subject }.to change(castle, :health_points).by(-siege_weapon.damage)
    end

    its([:action_result]) { is_expected.to include damages: siege_weapon.damage }
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
  end
end
