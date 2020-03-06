require 'rails_helper'

RSpec.describe OngoingTask::Task::PreChecksForTransaction do
  subject { described_class.call character: character, ongoing_task: ongoing_task }

  let(:camp) { create :camp, :with_buildings }
  let(:workshop) do
    camp
      .buildings
      .find { |b| b.is_a? Buildings::SiegeMachineWorkshop }
  end
  let(:ongoing_task) { workshop.ongoing_tasks.first }

  describe 'when every conditions are fullfilled' do
    let(:character) { create :character, camp: camp }

    it { is_expected.to be_success }
    its([:error]) { is_expected.to be_nil }
  end

  describe 'when character does not belong to this camp' do
    let(:character) { create :character, pseudonym: 'Cheater' }

    it { is_expected.to be_failure }
    its([:error]) { is_expected.to eq 'Cheater does not belong to this camp' }
  end

  describe 'when character is exhausted' do
    let(:character) { create :character, :exhausted, camp: camp, pseudonym: 'SleepingBeauty' }

    it { is_expected.to be_failure }
    its([:error]) { is_expected.to eq 'SleepingBeauty is exhausted, wait to get more points' }
  end

  describe 'when ongoing task is already completed and not repeatable' do
    let(:character) { create :character, camp: camp }
    let(:ongoing_task) { create :erect_task, :completed, :not_repeatable, taskable: workshop }

    it { is_expected.to be_failure }
    its([:error]) { is_expected.to eq 'This task is already completed and not repeatable' }
  end
end
