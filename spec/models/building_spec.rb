require 'rails_helper'

RSpec.describe Building, type: :model do
  it { is_expected.to have_db_column(:id).of_type(:uuid) }
  it { is_expected.to have_db_column(:type).of_type(:string) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  it { is_expected.to belong_to :camp }
  it { is_expected.to have_many(:ongoing_tasks).dependent(:destroy) }
end
