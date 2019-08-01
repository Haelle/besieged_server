require 'rails_helper'

RSpec.describe 'Defenders: :citizen' do
  subject { build :citizen, :armed }

  its(:tags) { are_expected.to include :citizen }

  describe '#counter_attack' do
    let(:targets) { build_list :infantry_squad, 2 }

    it 'attack targets randomly' do
      result = subject.counter_attack targets
      expect(result).to include infantry_squad: subject.damages
      expect(targets).to all be_damaged
    end
  end
end
