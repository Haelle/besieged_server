require 'rails_helper'

RSpec.describe Building::Create do
  subject { described_class.call camp: camp, type: type }

  let(:camp) { create :camp }
  let(:erected_building) { subject[:erected_building] }

  shared_examples 'a valid configuration' do |building_type|
    let(:type) { building_type }
    let(:config) { Rails.configuration.buildings[subject[:snake_type]] }

    it { is_expected.to be_success }

    its([:error]) { is_expected.to be_nil }

    it 'builds a new building' do
      expect { subject }.to change(camp.buildings, :count).by 1
    end

    it 'returns the new building' do
      expect(erected_building).to be_persisted
    end

    it 'erect a building of the expected type' do
      expect(erected_building).to be_a subject[:klass]
    end

    it 'belongs to the right camp' do
      expect(erected_building.camp).to be camp
    end

    it 'has expected ongoing tasks' do
      expect(erected_building.ongoing_tasks)
        .to have_exactly(config[:ongoing_tasks].size).items
    end
  end

  it_behaves_like 'a valid configuration', 'Buildings::SiegeMachineWorkshop'
  it_behaves_like 'a valid configuration', 'Buildings::TacticalOperationCenter'

  describe 'erecting an invalid building' do
    let(:type) { 'Buildings::SiegeMachineWorkshop' }

    before do
      allow(Rails.configuration).to receive(:buildings)
        .and_return(
          {
            siege_machine_workshop: {
              ongoing_tasks: [{
                type: 'NOT_A_TASK',
                action_points_required: 10,
                repeatable: true
              }]
            }
          }
        )
    end

    it { is_expected.to be_failure }

    it 'sets an error' do
      expect(subject[:error]).to eq 'NOT_A_TASK is not a class'
    end

    it 'does not erect any building' do
      expect { subject }.not_to change(Building, :count)
    end
  end

  describe 'erecting a banana' do
    let(:type) { 'banana' }

    it { is_expected.to be_failure }

    it 'sets an error' do
      expect(subject[:error]).to eq 'banana type is not found'
    end

    it 'does not erect any building' do
      expect { subject }.not_to change(Building, :count)
    end
  end
end
