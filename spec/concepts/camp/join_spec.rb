require 'rails_helper'

RSpec.describe Camp::Join do
  subject { described_class.call account: account, camp: camp, pseudonym: pseudonym }

  let(:account) { create :account }
  let(:camp) { create :camp }
  let(:pseudonym) { 'pseudo' }

  context 'when join went fine' do
    it { is_expected.to be_success }

    it 'creates a new character' do
      expect { subject }.to change(Character, :count).by 1
    end

    it 'creates a character linked to account & camp' do
      subject
      new_character = subject[:character]
      expect(new_character).to have_attributes(
        pseudonym: pseudonym,
        action_points: 6
      )
      expect(new_character.camp).to eq camp
      expect(new_character.account).to eq account
    end

    its([:action_result]) { is_expected.to include character: be_a(Character) }
  end

  context 'when account already have a character in the camp' do
    before do
      create :character, account: account, camp: camp
    end

    it { is_expected.to be_failure }

    it 'does not create a character' do
      expect { subject }.not_to change(Character, :count)
    end

    its([:error]) { is_expected.to eq 'an account can only have one character per camp' }
  end
end
