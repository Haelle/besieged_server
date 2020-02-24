require 'rails_helper'

RSpec.describe SiegeMachine, type: :model do
  it { is_expected.to have_db_column(:id).of_type(:uuid) }
  it { is_expected.to have_db_column(:damages).of_type(:integer) }
  it { is_expected.to have_db_column(:name).of_type(:string) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  it { is_expected.to belong_to :camp }

  describe '#valid' do
    context 'with valid attributes' do
      it 'is valid to build a catapult' do
        catapult = build :catapult
        expect(catapult.siege_machine_type).to eq 'catapult'
        expect(catapult).to be_valid
      end

      it 'is valid to build a ballista' do
        ballista = build :ballista
        expect(ballista.siege_machine_type).to eq 'ballista'
        expect(ballista).to be_valid
      end

      it 'is valid to build a trebuchet' do
        trebuchet = build :trebuchet
        expect(trebuchet.siege_machine_type).to eq 'trebuchet'
        expect(trebuchet).to be_valid
      end
    end

    context 'with invalid attributes' do
      it 'has nil damages' do
        invalid_siege_machine = build :invalid_siege_machine
        expect(invalid_siege_machine).to be_invalid
        expect(invalid_siege_machine.errors.messages).to include(
          damages: ["can't be blank"],
          name: ["can't be blank"]
        )
      end

      it 'is invalid to build a duck' do
        duck = build :siege_machine, siege_machine_type: 'duck'
        expect(duck).to be_invalid
      end
    end
  end
end
