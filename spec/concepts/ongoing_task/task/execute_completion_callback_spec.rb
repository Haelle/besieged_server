require 'rails_helper'

RSpec.describe OngoingTask::Task::ExecuteCompletionCallback do
  subject { described_class.call ongoing_task: ongoing_task }

  context 'when ongoing task is not completed yet' do
    let(:ongoing_task) { create :arm_task }

    it { is_expected.to be_success }

    its([:ongoing_task_status]) { is_expected.to eq 'ongoing' }
    its([:target]) { is_expected.to be_nil }
    its([:error]) { is_expected.to be_nil }

    it 'does not execute on completion callback' do
      expect(ongoing_task).not_to receive(:on_completion_callback)
      subject
    end
  end

  context 'when ongoing task is completed and repeatable' do
    let(:ongoing_task) { create :arm_task, :completed, :repeatable }

    it { is_expected.to be_success }

    its([:ongoing_task_status]) { is_expected.to eq 'completed' }
    its([:target]) { is_expected.to be_a Castle }
    its([:error]) { is_expected.to be_nil }

    it 'executes on completion callback' do
      expect(ongoing_task)
        .to receive(:on_completion_callback)
        .and_return(true)

      subject
    end

    it 'resets action points spent to 0' do
      expect { subject; ongoing_task.reload }
        .to change(ongoing_task, :action_points_spent)
        .from(ongoing_task.action_points_required)
        .to(0)
    end
  end

  context 'when ongoing task is completed NOT repeatable' do
    let(:ongoing_task) { create :arm_task, :completed, :not_repeatable }

    it { is_expected.to be_success }

    its([:ongoing_task_status]) { is_expected.to eq 'completed' }
    its([:target]) { is_expected.to be_a Castle }
    its([:error]) { is_expected.to be_nil }

    it 'executes on completion callback' do
      expect(ongoing_task)
        .to receive(:on_completion_callback)
        .and_return(true)

      subject
    end

    it 'resets action points spent to 0' do
      expect { subject; ongoing_task.reload }.not_to change(ongoing_task, :action_points_spent)
    end
  end

  context 'when callback failed' do
    before do
      castle = ongoing_task.target
      allow(castle).to receive(:save).and_return(false)
    end

    let(:ongoing_task) { create :arm_task, :completed }

    it { is_expected.to be_failure }

    its([:ongoing_task_status]) { is_expected.to be_nil }
    its([:target]) { is_expected.to be_nil }
    its([:error]) { is_expected.to eq 'Failed to fire upon the castle' }

    it 'executes on completion callback' do
      expect(ongoing_task)
        .to receive(:on_completion_callback)
        .and_return(false)

      subject
    end
  end
end
