require 'rails_helper'

RSpec.describe OngoingTasks::SiegeMachine::ArmTask do
  subject { create :arm_task }

  let(:camp) { subject.siege_machine.camp }
  let(:castle) { camp.castle }

  its(:target) { is_expected.to be castle }
  its(:camp) { is_expected.to be camp }

  describe '#on_completion_callback' do
    context 'when callback went fine' do
      it 'injures the castle' do
        expect { subject.on_completion_callback; camp.castle.reload }.to change(castle, :health_points).by(-1)
      end

      it 'locks the target' do
        expect(subject.target).to receive(:lock!)
        subject.on_completion_callback
      end

      it 'returns a truthy value on callback' do
        expect(subject.on_completion_callback).to be_truthy
      end
    end

    context 'when callback failed' do
      before do
        allow(castle).to receive(:save).and_return(false)
      end

      it 'does not injure the castle' do
        expect { subject.on_completion_callback; camp.castle.reload }.not_to change(castle, :health_points)
      end

      it 'returns a falsey value on callback' do
        expect(subject.on_completion_callback).to be_falsey
      end

      it 'returns an error' do
        subject.on_completion_callback
        expect(subject.error).to eq 'Failed to fire upon the castle'
      end
    end
  end
end
