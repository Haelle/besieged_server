require 'rails_helper'

RSpec.describe OngoingTask::Task::ActionPointsTransaction do
  subject { described_class.call character: character, ongoing_task: ongoing_task }

  let(:character) { create :character }
  let(:ongoing_task) { create :arm_task }

  context 'when everything went fine' do
    it { is_expected.to be_success }

    it 'decrement character action points' do
      expect { subject }.to change(character, :action_points).by(-1)
    end

    it 'increment ongoing task point spent' do
      expect { subject }.to change(ongoing_task, :action_points_spent).by 1
    end
  end

  context 'when character is exhausted' do
    let(:character) { create :character, :exhausted }

    it { is_expected.to be_failure }
    its([:error]) { is_expected.to eq 'Faild to decrement character: {:action_points=>["action_points cannot be lower than 0 and greater thant 24"]}' }
  end

  context 'when task is already completed' do
    let(:ongoing_task) { create :arm_task, :completed, :not_repeatable }

    it { is_expected.to be_failure }
    its([:error]) { is_expected.to eq 'Failed to increment ongoing task: {:logic=>["cannot spend more action points than required"]}' }
  end
end
