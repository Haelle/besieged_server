require 'rails_helper'

RSpec.describe 'SiegeMachines ongoing tasks', type: :request do
  include_context 'starting camp'

  before { Building::Create.call camp: camp, type: Buildings::SiegeMachineWorkshop }

  shared_examples 'firing upon the castle' do |machine_type|
    let(:machine) { get_siege_machine_type(machine_type).first }

    before { SiegeMachine::Create.call camp: camp, type: machine_type }

    it "fires with a #{machine_type}" do
      expect(castle.health_points).to eq 5_000
      complete_task arm_task_of(machine_type)
      expect(castle.health_points).to eq(5_000 - machine.damages)
    end
  end

  it_behaves_like 'firing upon the castle', SiegeMachines::Catapult
  it_behaves_like 'firing upon the castle', SiegeMachines::Ballista
  it_behaves_like 'firing upon the castle', SiegeMachines::Trebuchet
end
