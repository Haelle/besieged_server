require 'rails_helper'

RSpec.describe CampBlueprint do
  it 'renders one camp' do
    json = described_class.render(create(:settled_camp))
    expect(json).to match_json_schema 'camp'
  end

  it 'renders many camps' do
    json = described_class.render(create_list(:settled_camp, 5))
    expect(json).to match_json_schema 'camps'
  end
end
