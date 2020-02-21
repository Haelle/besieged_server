require 'rails_helper'

describe Character::Operate, :trb do
  subject do
    described_class.call(
      character: character,
      action_type: action_type,
      params: params,
      target: catapult,
      callback: callback
    )
  end

  let(:character) { create :character }
  let(:catapult) { create :catapult }
  let(:params) { { 'new_name' => 'this is a new name' } }
  let(:action_type) { 'update_machine_name' }
  let(:callback) do
    ->(_character, target, params) { target.update(name: params['new_name']) }
  end

  shared_examples 'locking resources' do
    it 'locks the character' do
      expect(character).to receive(:lock!)
      subject
    end

    it 'locks the target' do
      expect(catapult).to receive(:lock!)
      subject
    end
  end

  shared_examples 'character did not payed the cost' do
    it 'does not decrement character points'
  end

  context 'when everything is fine' do
    it { is_expected.to be_success }

    it_behaves_like 'locking resources'

    it 'decrements character points by one'

    it 'executes callback' do
      subject
      catapult.reload
      expect(catapult.name).to eq params['new_name']
    end

    it 'persists a CharacterAction' do
      expect { subject }.to change(CharacterAction, :count).by 1
    end

    it 'returns a valid CharacterAction' do
      action = subject[:action]
      expect(action).to be_persisted
      expect(action.character).to eq character
      expect(action.camp).to eq character.camp
      expect(action.action_type).to eq 'update_machine_name'
      expect(action.action_params).to eq params
      expect(action.target).to eq catapult
    end
  end

  context 'when character is exhausted' do
    before do
      allow_any_instance_of(Character).to receive(:exhausted?).and_return(true)
    end

    it { is_expected.to be_failure }

    it_behaves_like 'locking resources'
    it_behaves_like 'character did not payed the cost'

    it 'does not execute callback' do
      old_name = catapult.name
      subject
      catapult.reload
      expect(catapult.name).to eq old_name
    end

    it 'does not persist a CharacterAction' do
      expect { subject }.not_to change(CharacterAction, :count)
    end

    it 'stores an error' do
      expect(subject[:error]).to eq 'Kevin is exhausted, wait to get more points'
    end
  end

  context 'when callback returns a falsey result' do
    let(:callback) do
      ->(_character, _target, _params) { return false }
    end

    it { is_expected.to be_failure }

    it_behaves_like 'locking resources'
    it_behaves_like 'character did not payed the cost'

    it 'does not persist a CharacterAction' do
      expect { subject }.not_to change(CharacterAction, :count)
    end

    it 'stores an error' do
      expect(subject[:error]).to eq "An error occured during #{action_type}"
    end

    it 'logs an error' do
      expect(Rails.logger).to receive(:error)
        .with("#{action_type} by Kevin (#{character.id}) on Catapult - #{catapult.name} (#{catapult.id}) failed")
      subject
    end
  end

  context 'when CharacterAction cannot be persisted' do
    before do
      allow(CharacterAction).to receive(:create).and_return false
    end

    it { is_expected.to be_failure }

    it_behaves_like 'locking resources'
    it_behaves_like 'character did not payed the cost'

    it 'does not execute callback' do
      old_name = catapult.name
      subject
      catapult.reload
      expect(catapult.name).to eq old_name
    end

    it 'stores an error' do
      expect(subject[:error]).to eq 'Cannot execute action, unexpected behavior'
    end

    it 'logs an error' do
      expect(Rails.logger).to receive(:error)
        .with("CharacterAction persist failed (character: #{character.id}, action type: #{action_type}, params: #{params}, target: Catapult - #{catapult.id})")
      subject
    end
  end
end
