require 'rails_helper'

RSpec.describe Camp, type: :model do
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  it { is_expected.to have_many :characters }
  it { is_expected.to have_many :siege_weapons }
  it { is_expected.to have_one :castle }
end
