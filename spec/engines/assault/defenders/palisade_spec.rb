require 'rails_helper'

RSpec.describe 'Defenders: :palisade' do
  subject { build :palisade }

  its(:tags) { are_expected.to include :wall, :defense_structure }

  describe '#counter_attack' do
    let(:targets) { build_list :infantry_squad, 2 }

    it 'does not counter attack' do
      result = subject.counter_attack targets
      expect(result).to be_empty
      expect(targets).to all be_full_life
    end
  end
end
