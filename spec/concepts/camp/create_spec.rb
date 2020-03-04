require 'rails_helper'

RSpec.describe Camp::Create do
  subject(:operation) { described_class.call }

  context 'when camp is created' do
    let(:camp) { operation[:camp] }

    it { is_expected.to be_success }
    its([:camp]) { is_expected.to be_a Camp }
    its([:camp]) { is_expected.to be_persisted }

    it 'create a new camp' do
      expect { subject }.to change(Camp, :count).by 1
    end

    describe 'the tactical operation center' do
      subject { operation[:camp].toc }

      it { is_expected.to be_a Building }
      it { is_expected.to be_persisted }
      its(:ongoing_tasks) { are_expected.to have_exactly(1).items }
      its(:ongoing_tasks) { are_expected.to all be_an OngoingTask }
      its(:ongoing_tasks) { are_expected.to all be_persisted }
    end

    describe 'the castle' do
      subject { operation[:camp].castle }

      it { is_expected.to be_a Castle }
      it { is_expected.to be_persisted }
      its(:health_points) { are_expected.to eq 5_000 }
    end
  end

  context 'when something went wrong' do
    before do
      allow_any_instance_of(Camp).to receive(:reload).and_return(false)
    end

    it 'does not create a camp' do
      expect { subject }.not_to change(Camp, :count)
    end

    it 'does not create a toc' do
      expect { subject }.not_to change(Building, :count)
    end

    it 'does not create a castle' do
      expect { subject }.not_to change(Castle, :count)
    end
  end
end
