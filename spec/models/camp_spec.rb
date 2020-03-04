require 'rails_helper'

RSpec.describe Camp, type: :model do
  it { is_expected.to have_db_column(:id).of_type(:uuid) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  it { is_expected.to have_many(:characters).dependent(:destroy) }
  it { is_expected.to have_many(:siege_machines).dependent(:destroy) }
  it { is_expected.to have_many(:buildings).dependent(:destroy) }
  it { is_expected.to have_one(:castle).dependent(:destroy) }

  describe '#undergo_assault' do
    subject { create :camp }

    it 'yield all siege_machines to the attacking method' do
      expect { |block| subject.undergo_assault(&block) }
        .to yield_successive_args(*subject.siege_machines)
    end
  end
end
