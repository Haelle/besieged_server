require 'rails_helper'

RSpec.describe OngoingTasks::Building::ErectTask do
  subject { create :erect_task }

  let(:camp) { subject.building.camp }

  it 'set the target after the callback' do
    subject.on_completion_callback
    target = subject.target
    expect(target).to be_a Buildings::SiegeMachineWorkshop
    expect(target.ongoing_tasks).to have_exactly(3).items
  end

  its(:camp) { is_expected.to be camp }

  describe '#on_completion_callback' do
    context 'when callback went fine' do
      it 'erects a new building' do
        expect { subject.on_completion_callback; camp.buildings.reload }
          .to change(camp.buildings, :count).by 1
      end

      it 'returns a truthy value on callback' do
        expect(subject.on_completion_callback).to be_truthy
      end
    end

    context 'when callback failed' do
      before do
        allow(Building::Create)
          .to receive(:call)
          .with(camp: camp, type: 'Buildings::SiegeMachineWorkshop')
          .and_return(trb_result_failure_with(error: 'dummy error'))
      end

      it 'does not erect any building' do
        expect { subject.on_completion_callback; camp.buildings.reload }.not_to change(Building, :count)
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
