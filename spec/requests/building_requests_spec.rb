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
  end
end
