require 'rails_helper'

RSpec.describe Assault::Engine, :pending do
  subject { described_class.new round_count: 2, assaulters: assaulters }

  let(:assaulters) { build_list :infantry_squad, 2 }
  let(:weak_defenders) { build_list :citizen, 5, :armed }
  let(:weak_defenders_first_round_report) do
    {
      assaulters: [
        {
          infantry_squad: {
            damages_from: [{ citizen: 5 * 10 }],
            damages_to: [{ citizen: 2 * 10 }]
          }
        }
      ],
      defenders: [
        {
          citizen: {
            damages_from: [{ infantry_squad: 2 * 10 }],
            damages_to: [{ infantry_squad: 5 * 10 }]
          }
        }
      ]
    }
  end

  describe '#assault_on' do
    example 'assaulters kills everyone in one round' do
      expect { |b| subject.assault_on weak_defenders(&b) }
        .to yield_successive_args(weak_defenders_first_round_report, nil)
    end

    it 'kills all defenders' do
      subject.assault_on weak_defenders
      expect(subject.defenders).to all be_dead
    end
  end

  describe '#report' do
    before { subject.assault_on weak_defenders }

    it 'returns damages summary' do
      expect(subject.report).to eq weak_defenders_first_round_report
    end
  end
end
