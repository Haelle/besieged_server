require 'rails_helper'

RSpec.describe SiegeMachine::Create do
  subject { described_class.call camp: camp, siege_machine_type: type }

  let(:camp) { create :camp }
  let(:built_machine) { subject[:siege_machine] }

  describe 'building a catapult' do
    let(:type) { 'catapult' }

    it { is_expected.to be_success }

    it 'builds a new weapon' do
      expect { subject }.to change(camp.siege_machines, :count).by 1
    end

    it 'returns the new weapon' do
      expect(built_machine).to be_persisted
    end

    it 'builds a machine o the expected type' do
      expect(built_machine.siege_machine_type).to eq type
    end

    it 'build a new weapon with a random name' do
      expect(built_machine.name).to be_a String
      expect(built_machine.name.size).to be >= 5
    end
  end

  describe 'building a duck' do
    let(:type) { 'duck' }

    it { is_expected.to be_failure }

    it 'does not build anything' do
      expect { subject }.not_to change(SiegeMachine, :count)
    end

    it 'does not return anyhting' do
      expect(built_machine).not_to be_persisted
    end
  end
end
