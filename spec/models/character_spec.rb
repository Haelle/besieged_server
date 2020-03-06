require 'rails_helper'

RSpec.describe Character, type: :model do
  it { is_expected.to have_db_column(:id).of_type(:uuid) }
  it { is_expected.to have_db_column(:pseudonym).of_type(:string) }
  it { is_expected.to have_db_column(:action_points).of_type(:integer).with_options(default: 0) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  it { is_expected.to belong_to :account }
  it { is_expected.to belong_to :camp }

  describe '#valid' do
    it 'is valid' do
      expect(build(:character)).to be_valid
    end

    it 'has nil pseudonym' do
      invalid_character = build :invalid_character
      expect(invalid_character).to be_invalid
      expect(invalid_character.errors.messages).to include pseudonym: ["can't be blank"]
    end

    it 'is invalid to have 2 characters in the same camp' do
      camp = create :camp
      account = create :account
      create :character, account: account, camp: camp
      invalid_character = build :character, account: account, camp: camp

      expect(invalid_character).to be_invalid
      expect(invalid_character.errors.messages)
        .to include camp: ['an account can only have one character per camp']
    end
  end

  describe 'action points' do
    subject { create :character, action_points: 9 }

    it 'has a default max action points' do
      expect(subject.max_action_points).to eq 24
    end

    it 'has a default action point regeneration rate' do
      expect(subject.action_point_regeneration_rate).to eq 6
    end

    its([:action_points]) { are_expected.to eq 9 }

    it 'cannot have less than 0 action point' do
      over_exhausted_character = build :character, action_points: -1
      expect(over_exhausted_character).to be_invalid
      expect(over_exhausted_character.errors.messages)
        .to include action_points: ['action_points cannot be lower than 0 and greater thant 24']
    end

    it 'cannot have more than 24 action point' do
      cheating_character = build :character, action_points: 25
      expect(cheating_character).not_to be_valid
      expect(cheating_character.errors.messages)
        .to include action_points: ['action_points cannot be lower than 0 and greater thant 24']
    end

    describe '#exhausted?' do
      it 'is not exhausted' do
        character = create :character, action_points: 2
        expect(character).not_to be_exhausted
      end

      it 'is exhausted' do
        character = create :character, action_points: 0
        expect(character).to be_exhausted
      end
    end
  end
end
