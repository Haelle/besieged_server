require 'rails_helper'

RSpec.describe Account, type: :model do
  it { is_expected.to have_db_column(:id).of_type(:uuid) }
  it { is_expected.to have_db_column(:email).of_type(:string) }
  it { is_expected.to have_db_column(:admin).of_type(:boolean).with_options(default: false) }
  it { is_expected.to have_db_column(:password_digest).of_type(:string) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  it 'is valid' do
    expect(build :account).to be_valid
  end

  it 'has invalid email' do
    invalid_account = build :invalid_account
    expect(invalid_account).to be_invalid
    expect(invalid_account.errors.messages).to include email: ['is invalid']
  end

  example 'email already exists' do
    create :account

    invalid_account = build :account
    expect(invalid_account).to be_invalid
    expect(invalid_account.errors.messages).to include email: ['has already been taken']
  end

  it 'needs a password' do
    invalid_account = build :account, password: nil
    expect(invalid_account).to be_invalid
    expect(invalid_account.errors.messages).to include password: ["can't be blank"]
  end
end
