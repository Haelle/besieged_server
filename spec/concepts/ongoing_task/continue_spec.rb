require 'rails_helper'

RSpec.describe OngoingTask::Continue, :trb do
  subject do
    described_class.call(
      ongoing_task: ongoing_task,
      character: character
    )
  end

  include_context 'basic game'

  shared_examples 'locking resources' do
    it 'locks the character' do
      expect(character).to receive(:lock!)
      subject
    end

    it 'locks the ongoing task' do
      expect(ongoing_task).to receive(:lock!)
      subject
    end
  end

  context 'when the task is not completed yet' do
    it { is_expected.to be_success }
    its([:ongoing_task_status]) { is_expected.to eq 'ongoing' }

    it_behaves_like 'locking resources'
    it_behaves_like 'character payed the AP cost'
    it_behaves_like 'continuing ongoing task by one point'

    it 'calls subprocess PreChecksForTransaction' do
      expect_to_call_nested_operation(OngoingTask::Task::PreChecksForTransaction)
      subject
    end

    it 'calls subprocess ActionPointsTransaction' do
      expect_to_call_nested_operation(OngoingTask::Task::ActionPointsTransaction)
      subject
    end

    it 'calls subprocess ExecuteCompletionCallback' do
      expect_to_call_nested_operation(OngoingTask::Task::ExecuteCompletionCallback)
      subject
    end

    it 'does not execute the callback' do
      expect(ongoing_task).not_to receive(:on_completion_callback)
      subject
    end

    it 'can be serialized with blueprint' do
      json = OngoingTaskResultBlueprint.render(subject)
      expect(json).to match_json_schema 'ongoing_task_result_still_ongoing'
    end
  end

  context 'when task is now completed!' do
    let(:ongoing_task) { create :arm_task, :almost_completed, taskable: siege_machine }

    it { is_expected.to be_success }
    its([:ongoing_task_status]) { is_expected.to eq 'completed' }

    it_behaves_like 'locking resources'
    it_behaves_like 'character payed the AP cost'
    it_behaves_like 'continuing ongoing task by one point'

    it 'calls subprocess PreChecksForTransaction' do
      expect_to_call_nested_operation(OngoingTask::Task::PreChecksForTransaction)
      subject
    end

    it 'calls subprocess ActionPointsTransaction' do
      expect_to_call_nested_operation(OngoingTask::Task::ActionPointsTransaction)
      subject
    end

    it 'calls subprocess ExecuteCompletionCallback' do
      expect_to_call_nested_operation(OngoingTask::Task::ExecuteCompletionCallback)
      subject
    end

    it 'executes the callback' do
      expect(ongoing_task).to receive(:on_completion_callback)
      subject
    end

    it 'can be serialized with blueprint' do
      json = OngoingTaskResultBlueprint.render(subject)
      expect(json).to match_json_schema 'ongoing_task_result_completed'
    end
  end

  context 'when character is exhausted' do
    before { character.update action_points: 0 }

    it { is_expected.to be_failure }
    its([:ongoing_task_status]) { is_expected.to be_nil }

    it_behaves_like 'locking resources'
    it_behaves_like 'character did not pay the AP cost'

    its([:error]) { is_expected.to eq 'Kevin is exhausted, wait to get more points' }
  end
end
