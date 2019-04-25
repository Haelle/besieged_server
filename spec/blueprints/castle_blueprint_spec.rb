require 'rails_helper'

RSpec.describe CastleBlueprint do
  it 'renders one castle' do
    json = described_class.render(create :castle)
    expect(json).to match_json_schema 'castle'
  end

  it 'renders many castles' do
    json = described_class.render(create_list :castle, 5)
    expect(json).to match_json_schema 'castles'
  end
end
