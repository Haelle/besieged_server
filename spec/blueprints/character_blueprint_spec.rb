require 'rails_helper'

RSpec.describe CharacterBlueprint do
  it 'renders one character' do
    json = described_class.render(create :character)
    expect(json).to match_json_schema 'character'
  end

  it 'renders many characters' do
    json = described_class.render(create_list :character, 5)
    expect(json).to match_json_schema 'characters'
  end
end
