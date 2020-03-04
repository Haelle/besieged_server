require 'rails_helper'

RSpec.describe BuildingBlueprint do
  it 'renders one building' do
    json = described_class.render(
      create(:building, :with_ongoing_tasks)
    )
    expect(json).to match_json_schema 'building'
  end

  it 'renders many buildings' do
    json = described_class.render(
      create_list(:building, 5, :with_ongoing_tasks)
    )
    expect(json).to match_json_schema 'buildings'
  end
end
