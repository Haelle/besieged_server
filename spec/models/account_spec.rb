require 'rails_helper'

RSpec.describe Account, type: :model do
  it { is_expected.to have_db_column(:id).of_type(:uuid) }
  it { is_expected.to have_db_column(:email).of_type(:string) }
  it { is_expected.to have_db_column(:admin).of_type(:boolean).with_options(default: false) }
  it { is_expected.to have_db_column(:password_digest).of_type(:string) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  it { is_expected.to have_many(:characters) }

  it 'is valid' do
    expect(build(:account)).to be_valid
  end

  it 'has invalid email' do
    invalid_account = build :invalid_account
    expect(invalid_account).to be_invalid
    expect(invalid_account.errors.messages).to include email: ['is invalid']
  end

  example 'email already exists' do
    duplicate_email = 'test@email.com'
    create :account, email: duplicate_email

    invalid_account = build :account, email: duplicate_email
    expect(invalid_account).to be_invalid
    expect(invalid_account.errors.messages).to include email: ['has already been taken']
  end

  it 'needs a password' do
    invalid_account = build :account, password: nil
    expect(invalid_account).to be_invalid
    expect(invalid_account.errors.messages).to include password: ["can't be blank"]
  end

  it 'never returns password_digest in as_json' do
    account = create :account
    expect(account.as_json.key?('password_digest')).to be_falsey
    expect(account.as_json.key?(:password_digest)).to be_falsey
  end

  describe '#update_with_password' do
    let(:account) { create :account }
    let(:account_attributes) do
      account.attributes.symbolize_keys.tap do |h|
        h.delete :password_digest
      end
    end

    it 'updates data when password is valid' do
      account_attributes[:current_password] = 'password'
      account_attributes[:email] = 'new@email.com'

      result = account.update_with_password account_attributes
      account.reload
      expect(result).to be_truthy
      expect(account).to have_attributes email: 'new@email.com'
    end

    it 'returns false when data are invalids' do
      account_attributes[:current_password] = 'password'
      account_attributes[:email] = 'wrong email'

      result = account.update_with_password account_attributes
      expect(result).to be_falsey
    end

    it 'does not update data when password is invalid' do
      account_attributes[:current_password] = 'wrong password'

      result = account.update_with_password account_attributes
      expect(result).to be_falsey
      expect(account.errors.messages).to include current_password: ['is invalid']
    end

    it 'does not update data when password is blank' do
      result = account.update_with_password account_attributes
      expect(result).to be_falsey
      expect(account.errors.messages).to include current_password: ['can\'t be blank']
    end
  end
end
