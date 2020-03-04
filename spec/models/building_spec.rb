require 'rails_helper'

RSpec.describe Building, type: :model do
  it { is_expected.to have_db_column(:id).of_type(:uuid) }
  it { is_expected.to have_db_column(:building_type).of_type(:string) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  it { is_expected.to belong_to :camp }
  it { is_expected.to have_many(:ongoing_tasks).dependent(:destroy) }

  describe '#valid?' do
    it 'is valid to build a siege machine workshop' do
      workshop = build :siege_machine_workshop
      expect(workshop.building_type).to eq 'siege_machine_workshop'
      expect(workshop).to be_valid
    end

    it 'is valid to build a TOC' do
      toc = build :tactical_operation_center
      expect(toc.building_type).to eq 'tactical_operation_center'
      expect(toc).to be_valid
    end

    it 'is invalid to build a nursery' do
      nursery = build :building, building_type: 'nursery'
      expect(nursery).to be_invalid
    end
  end
end
