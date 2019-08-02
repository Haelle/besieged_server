require 'rails_helper'

RSpec.describe 'Assaulter: :archer_squad' do
  subject { build :archer_squad }

  its(:tags) { are_expected.to include :archer }

  describe '#attack' do
    let(:palisade) { build :palisade }
    let(:few_citizens) { build_list :citizen, 4 }
    let(:a_lot_of_citizens) { build_list :citizen, 24 }

    it 'deals only 1 damage to every targets' do
      targets = [a_lot_of_citizens, palisade].flatten
      result = subject.attack targets
      expect(result).to include citizen: 24, palisade: 1
      expect(a_lot_of_citizens).to all have_attributes health_points: 9
      expect(palisade.health_points).to eq 149
    end

    it 'deals another damage if some damages remains' do
      targets = [few_citizens, palisade].flatten
      result = subject.attack targets
      expect(result).to include citizen: 20, palisade: 5
      expect(few_citizens).to all have_attributes health_points: 5
      expect(palisade.health_points).to eq 145
    end
  end
end
