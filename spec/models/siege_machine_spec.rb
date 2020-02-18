require 'rails_helper'

RSpec.describe SiegeMachine, type: :model do
  it { is_expected.to have_db_column(:id).of_type(:uuid) }
  it { is_expected.to have_db_column(:damages).of_type(:integer) }
  it { is_expected.to have_db_column(:name).of_type(:string) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  it { is_expected.to belong_to :camp }

  it 'is valid' do
    expect(build(:siege_machine)).to be_valid
  end

  it 'has nil damages' do
    invalid_siege_machine = build :invalid_siege_machine
    expect(invalid_siege_machine).to be_invalid
    expect(invalid_siege_machine.errors.messages).to include(
      damages: ["can't be blank"],
      name: ["can't be blank"]
    )
  end
end
