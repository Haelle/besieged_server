require 'rails_helper'

RSpec.describe CharacterAction, type: :model do
  it { is_expected.to have_db_column(:id).of_type(:uuid) }
  it { is_expected.to have_db_column(:camp_id).of_type(:string) }
  it { is_expected.to have_db_column(:character_id).of_type(:string) }
  it { is_expected.to have_db_column(:action_type).of_type(:string) }
  it { is_expected.to have_db_column(:action_params).of_type(:json) }
  it { is_expected.to have_db_column(:target_id).of_type(:string) }
  it { is_expected.to have_db_column(:target_type).of_type(:string) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  it { is_expected.to belong_to :camp }
  it { is_expected.to belong_to :character }

  describe '#target' do
    it 'links target to target_type and id' do
      catapult = create :catapult
      action = create :character_action
      action.target = catapult

      expect(action.target_id).to eq catapult.id
      expect(action.target_type).to eq catapult.class.to_s
    end

    it 'links target type and id to a target' do
      catapult = create :catapult
      action = create :character_action, target_id: catapult.id, target_type: catapult.class.name

      expect(action.target).to eq catapult
    end
  end

  describe '#valid?' do
    it 'is valid' do
      expect(build(:character_action)).to be_valid
    end

    it 'is invalid' do
      invalid_character_action = build :invalid_character_action
      expect(invalid_character_action).to be_invalid
      expect(invalid_character_action.errors.messages).to include(
        action_type: ["can't be blank"],
        target_id: ["can't be blank"],
        target_type: ["can't be blank"]
      )
    end
  end
end
