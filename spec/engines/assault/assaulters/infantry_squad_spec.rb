require 'rails_helper'

RSpec.describe 'Assaulters: :infantry_squad' do
  subject { build :infantry_squad }

  its(:tags) { are_expected.to include :infantry }

  describe '#attack' do
    let(:citizens) { build_list :citizen, 2 }
    let(:damaged_palisade) { build :palisade, :heavily_damaged }
    let(:palisade) { build :palisade }

    it 'attack in priority the palisade (defense structure)' do
      result = subject.attack [citizens, palisade].flatten
      expect(result).to include palisade: 20
      expect(citizens).to all be_full_life
    end

    it 'attacks citizen if the rest is destroyed' do
      result = subject.attack [citizens, damaged_palisade].flatten
      expect(result).to include palisade: 15, citizen: a_value_within(2).of(5)
      expect(damaged_palisade).to be_destroyed
      expect(citizens.select(&:injured?)).not_to be_empty
    end
  end
end
