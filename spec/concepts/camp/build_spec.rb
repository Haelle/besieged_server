require 'rails_helper'

RSpec.describe Camp::Build do
  subject { described_class.call camp: camp, character: character, siege_machine_type: 'catapult' }

  context 'when building went fine' do
    include_context 'basic game'

    let(:built_machine) { subject[:siege_machine] }

    it { is_expected.to be_success }

    it 'builds a new weapon' do
      expect { subject }.to change(camp.siege_machines, :count).by 1
    end

    it 'returns the new weapon' do
      expect(built_machine).to be_persisted
    end

    it 'builds a machine o the expected type' do
      expect(built_machine.siege_machine_type).to eq 'catapult'
    end

    it 'build a new weapon with a random name' do
      expect(built_machine.name).to be_a String
      expect(built_machine.name.size).to be >= 5
    end

    its([:camp]) { is_expected.to eq camp }
    its([:status]) { is_expected.to eq 'built' }
    its([:siege_machine]) { is_expected.to eq built_machine }

    it 'persists a CharacterAction with expected values' do
      action = subject[:action]
      expect(action).to be_a CharacterAction
      expect(action).to be_persisted
      expect(action.character).to eq character
      expect(action.camp).to eq character.camp
      expect(action.action_type).to eq 'build'
      expect(action.action_params).to eq('siege_machine_type' => 'catapult')
      expect(action.target).to eq camp
    end
  end

  context 'when user does not belongs to this camp' do
    let(:camp) { create :camp }
    let(:character) { create :character, account: account_from_headers }

    it_behaves_like 'interfering with another camp'

    it 'does not build the weapon' do
      expect { subject }.not_to change(camp.siege_machines, :count)
    end
  end

  context 'when build callback failed' do
    include_context 'basic game'

    before do
      allow(SiegeMachine).to receive(:create).and_return false
    end

    it { is_expected.to be_failure }

    it 'does not decrement character points'

    it 'does not create a catapult' do
      expect { subject; camp.reload }.not_to change(camp.siege_machines, :count)
    end

    its([:error]) { is_expected.to eq 'An error occurred during build' }

    it 'does not persist a character action' do
      expect { subject }.not_to change(CharacterAction, :count)
    end
  end
end
