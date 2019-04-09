require 'rails_helper'

RSpec.describe Castle, type: :model do
  it { is_expected.to have_db_column(:health_points).of_type(:integer) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  it { is_expected.to belong_to(:camp) }

  it 'is valid' do
    expect(build(:castle)).to be_valid
  end

  it 'has nil health_points' do
    invalid_castle = build :invalid_castle
    expect(invalid_castle).to be_invalid
    expect(invalid_castle.errors.messages).to include health_points: ["can't be blank"]
  end
end
