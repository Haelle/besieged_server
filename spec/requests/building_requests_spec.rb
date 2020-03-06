require 'rails_helper'

RSpec.describe 'Buildings ongoing tasks', type: :request do
  include_context 'starting camp'

  it 'creates the siege machine workshop' do
    expect(workshop).to be_nil
    complete_task(erect_workshop_task)

    expect(camp.buildings).to have_exactly(2).items
    expect(workshop.ongoing_tasks).to have_exactly(3).items
  end

  context 'with a workshop' do
    before { Building::Create.call camp: camp, type: Buildings::SiegeMachineWorkshop }

    it 'assemble a catapult' do
      expect(catapults).to have_exactly(0).items

      complete_task assemble_task_of(SiegeMachines::Catapult)

      expect(catapults).to have_exactly(1).items
      expect(catapults.first.ongoing_tasks).to have_exactly(1).items
    end

    context 'with an existing camp' do
      before do
        SiegeMachine::Create.call camp: camp, type: SiegeMachines::Catapult
        SiegeMachine::Create.call camp: camp, type: SiegeMachines::Catapult
        SiegeMachine::Create.call camp: camp, type: SiegeMachines::Catapult
      end

      it 'creates a catapult in the gap' do
        machine_to_destroy = SiegeMachines::Catapult.find_by(camp: camp, position: 1)
        expect(machine_to_destroy).to be_persisted
        machine_to_destroy.destroy

        expect(catapults.map(&:position)).to include 0, 2
        complete_task assemble_task_of(SiegeMachines::Catapult)
        new_catapult = SiegeMachines::Catapult.where(camp: camp).order(:created_at).last
        expect(new_catapult.position).to eq 1
        expect(catapults.map(&:position)).to include 0, 1, 2
      end
    end
  end
end
