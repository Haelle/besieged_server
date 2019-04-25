require 'rails_helper'

RSpec.describe AccountBlueprint do
  it 'renders one account' do
    json = described_class.render(create(:account, :with_character))
    expect(json).to match_json_schema 'account'
  end

  it 'renders many accounts' do
    json = described_class.render(create_list(:account, 5, :with_character))
    expect(json).to match_json_schema 'accounts'
  end
end
