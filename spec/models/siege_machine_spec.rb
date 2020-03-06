require 'rails_helper'

RSpec.describe SiegeMachine, type: :model do
  it { is_expected.to have_db_column(:id).of_type(:uuid) }
  it { is_expected.to have_db_column(:type).of_type(:string) }
  it { is_expected.to have_db_column(:damages).of_type(:integer) }
  it { is_expected.to have_db_column(:name).of_type(:string) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  it { is_expected.to belong_to :camp }
  it { is_expected.to have_many(:ongoing_tasks).dependent(:destroy) }

  describe '#valid?' do
    it 'is valid to build a catapult' do
      catapult = build :catapult
      expect(catapult).to be_a SiegeMachines::Catapult
      expect(catapult).to be_valid
    end

    it 'has nil damages' do
      invalid_catapult = build :invalid_catapult
      expect(invalid_catapult).to be_invalid
      expect(invalid_catapult.errors.messages).to include(
        damages: ["can't be blank"],
        name: ["can't be blank"]
      )
    end
  end
end
