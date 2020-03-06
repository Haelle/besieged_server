require 'rails_helper'

RSpec.describe Character::RegenerateActionPoints do
  subject { described_class.call character: character }

  context 'when character has few action points' do
    let(:character) { create :character, action_points: 2 }

    it 'regenerate points by maximum possible' do
      expect { subject }.to change(character, :action_points).by 6
    end
  end

  context 'when character has almost max action points' do
    let(:character) { create :character, action_points: 23 }

    it 'regenerate points by maximum possible' do
      expect { subject }.to change(character, :action_points).by 1
    end
  end
end
