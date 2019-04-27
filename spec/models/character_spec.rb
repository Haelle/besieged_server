require 'rails_helper'

RSpec.describe Character, type: :model do
  it { is_expected.to have_db_column(:id).of_type(:uuid) }
  it { is_expected.to have_db_column(:pseudonyme).of_type(:string) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  it { is_expected.to belong_to :account }
  it { is_expected.to belong_to :camp }

  it 'is valid' do
    expect(build(:character)).to be_valid
  end

  it 'has nil pseudonyme' do
    invalid_character = build :invalid_character
    expect(invalid_character).to be_invalid
    expect(invalid_character.errors.messages).to include pseudonyme: ["can't be blank"]
  end

  it 'is invalid to have 2 characters in the same camp' do
    camp = create :camp
    account = create :account
    character = create :character, account: account, camp: camp
    invalid_character = build :character, account: account, camp: camp

    expect(invalid_character).to be_invalid
    expect(invalid_character.errors.messages).to include camp: ['an account can only have one character per camp']
  end
end
