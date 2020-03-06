require 'rails_helper'

RSpec.describe SiegeMachineBlueprint do
  it 'renders one weapon' do
    json = described_class.render(create(:trebuchet))
    expect(json).to match_json_schema 'siege_machine'
  end

  it 'renders many weapons' do
    json = described_class.render(create_list(:ballista, 5))
    expect(json).to match_json_schema 'siege_machines'
  end
end
