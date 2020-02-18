require 'rails_helper'

RSpec.describe SiegeMachineBlueprint do
  it 'renders one weapon' do
    json = described_class.render(create(:siege_machine))
    expect(json).to match_json_schema 'siege_machine'
  end

  it 'renders many weapons' do
    json = described_class.render(create_list(:siege_machine, 5))
    expect(json).to match_json_schema 'siege_machines'
  end
end
