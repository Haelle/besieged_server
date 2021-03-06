require 'rails_helper'

RSpec.describe CastleBlueprint do
  it 'renders one castle' do
    json = described_class.render(create(:castle, :with_armed_camp))
    expect(json).to match_json_schema 'castle'
  end

  it 'renders many castles' do
    json = described_class.render(create_list(:castle, 5, :with_armed_camp))
    expect(json).to match_json_schema 'castles'
  end
end
