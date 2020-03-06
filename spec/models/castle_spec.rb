require 'rails_helper'

RSpec.describe Castle, type: :model do
  it { is_expected.to have_db_column(:health_points).of_type(:integer) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  it { is_expected.to belong_to(:camp) }

  it 'is valid' do
    expect(build(:castle, :with_armed_camp)).to be_valid
  end

  it 'has nil health_points' do
    invalid_castle = build :invalid_castle
    expect(invalid_castle).to be_invalid
    expect(invalid_castle.errors.messages).to include health_points: ['is not a number']
  end

  it 'cannot have negative health points' do
    expect(build(:castle, health_points: -5)).to be_invalid
  end

  it 'destroys 3/8 machines' do
    castle = create :castle, :with_armed_camp
    allow(castle)
      .to receive(:target_destroyed?)
      .and_return(true, false, true, false, true, false, false, false)

    expect { castle.counter_attack }.to change { castle.camp.siege_machines.size }.by(-3)
  end

  it 'randomy destroys' do
    castle = Castle.new
    expect(castle.__send__(:target_destroyed?)).to be_in [true, false]
  end
end
