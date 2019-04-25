require 'rails_helper'

RSpec.describe CampBlueprint do
  it 'renders one camp' do
    json = described_class.render(
      create :camp, :with_castle, :with_characters, :with_weapons
    )
    expect(json).to match_json_schema 'camp'
  end

  it 'renders many camps' do
    json = described_class.render(
      create_list :camp, 5, :with_castle, :with_characters, :with_weapons
    )
    expect(json).to match_json_schema 'camps'
  end
end
