require 'rails_helper'

RSpec.describe OngoingTasks::Building::AssembleTask do
  subject { create :assemble_task }

  let(:camp) { subject.building.camp }

  it 'set the target after the callback' do
    subject.on_completion_callback
    target = subject.target
    expect(target).to be_a SiegeMachine
    expect(target.siege_machine_type).to eq 'catapult'
    expect(target.ongoing_tasks).to have_exactly(1).items
  end

  its(:camp) { is_expected.to be camp }

  describe '#on_completion_callback' do
    context 'when callback went fine' do
      it 'assemble a new siege machine' do
        expect { subject.on_completion_callback; camp.siege_machines.reload }
          .to change(camp.siege_machines, :count).by 1
      end

      it 'returns a truthy value on callback' do
        expect(subject.on_completion_callback).to be_truthy
      end
    end

    context 'went callback failed' do
      before do
        allow(SiegeMachine::Create)
          .to receive(:call)
          .with(camp: camp, siege_machine_type: 'catapult')
          .and_return(trb_result_failure_with(error: 'dummy error'))
      end

      it 'does not assemble any siege machine' do
        expect { subject.on_completion_callback; camp.siege_machines.reload }.not_to change(SiegeMachine, :count)
      end

      it 'returns a falsey value on callback' do
        expect(subject.on_completion_callback).to be_falsey
      end

      it 'returns an error' do
        subject.on_completion_callback
        expect(subject.error).to eq 'dummy error'
      end
    end
  end
end
