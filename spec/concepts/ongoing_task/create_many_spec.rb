require 'rails_helper'

RSpec.describe OngoingTask::CreateMany do
  subject { described_class.call configurations: configs, taskable: siege_machine }

  let(:siege_machine) { create :siege_machine }
  let(:valid_config) do
    {
      type: 'OngoingTasks::SiegeMachine::ArmTask',
      action_points_required: 10,
      repeatable: false
    }
  end

  context 'when the configurations are valid' do
    let(:explicit_valid_config) do
      {
        type: 'OngoingTasks::Building::AssembleTask',
        action_points_required: '100',
        repeatable: true,
        params: { p1: 'p1', p2: true }
      }
    end

    let(:configs) { [valid_config, explicit_valid_config] }

    it { is_expected.to be_success }

    its([:ongoing_tasks]) { are_expected.to all be_an OngoingTask }
    its([:ongoing_tasks]) { are_expected.to all be_valid }
    its([:ongoing_tasks]) { are_expected.to all be_persisted }
    its([:error]) { is_expected.to be_nil }
  end

  context 'when a configuration is invalid' do
    let(:configs) { [valid_config, invalid_config] }

    let(:invalid_config) do
      {
        type: 'NotFoundTaskType',
        action_points_required: 10,
        repeatable: false
      }
    end

    it { is_expected.to be_failure }
    its([:ongoing_tasks]) { are_expected.to be_empty }
    its([:error]) { is_expected.to eq 'NotFoundTaskType is not a class' }
  end
end
