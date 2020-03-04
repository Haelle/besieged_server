require 'rails_helper'

RSpec.describe OngoingTask::Create do
  subject { described_class.call configuration: config, taskable: taskable }

  let(:taskable) { create :building }

  valid_config = {
    type: 'OngoingTasks::SiegeMachine::ArmTask',
    action_points_required: 10,
    repeatable: false
  }

  another_valid_config = {
    type: 'OngoingTasks::Building::AssembleTask',
    action_points_required: '100',
    repeatable: true,
    params: { p1: 'p1', p2: true }
  }

  shared_examples 'creating from a valid configuration' do |configuration|
    let(:config) { configuration }

    it { is_expected.to be_success }

    its([:ongoing_task]) { is_expected.to be_a config[:type].constantize }
    its([:ongoing_task]) { is_expected.to be_valid }
    its([:ongoing_task]) { is_expected.to be_persisted }
    its([:ongoing_task]) { is_expected.to have_attributes params: config[:params].as_json }
    its([:ongoing_task]) { is_expected.to have_attributes action_points_spent: 0 }
    its([:ongoing_task]) { is_expected.to have_attributes action_points_required: config[:action_points_required].to_i }
    its([:ongoing_task]) { is_expected.to have_attributes repeatable: config[:repeatable] }
    its([:error]) { is_expected.to be_nil }
  end

  it_behaves_like 'creating from a valid configuration', valid_config
  it_behaves_like 'creating from a valid configuration', another_valid_config

  context 'when taskable is not set' do
    let(:taskable) { nil }
    let(:config) do
      {
        type: 'OngoingTasks::Building::AssembleTask',
        action_points_required: 0
      }
    end

    it { is_expected.to be_failure }
    its([:ongoing_task]) { is_expected.to be_nil }
    its([:error]) { is_expected.to eq 'Taskable must exist, Action points required must be greater than 0' }
  end

  context 'when a configuration is invalid' do
    let(:config) { invalid_config }

    context 'when type is not set' do
      let(:invalid_config) do
        {
          action_points_required: 10,
          repeatable: false
        }
      end

      it { is_expected.to be_failure }
      its([:ongoing_task]) { is_expected.to be_nil }
      its([:error]) { is_expected.to eq 'nil is not a class' }
    end

    context 'when type is not found' do
      let(:invalid_config) do
        {
          type: 'NotFoundTaskType',
          action_points_required: 10,
          repeatable: false
        }
      end

      it { is_expected.to be_failure }
      its([:ongoing_task]) { is_expected.to be_nil }
      its([:error]) { is_expected.to eq 'NotFoundTaskType is not a class' }
    end

    context 'when action_points_required is not an integer' do
      let(:invalid_config) do
        {
          type: 'OngoingTasks::Building::AssembleTask',
          action_points_required: 'eleven',
          repeatable: false
        }
      end

      it { is_expected.to be_failure }
      its([:ongoing_task]) { is_expected.to be_nil }
      its([:error]) { is_expected.to eq 'Action points required must be greater than 0' }
    end

    context 'when action_points_required is not set' do
      let(:invalid_config) do
        {
          type: 'OngoingTasks::Building::AssembleTask',
          repeatable: false
        }
      end

      it { is_expected.to be_failure }
      its([:ongoing_task]) { is_expected.to be_nil }
      its([:error]) { is_expected.to eq 'Action points required must be greater than 0' }
    end
  end
end
