require 'rails_helper'

RSpec.describe Assault::Alive do
  subject do
    Class.new do
      include ActiveModel::Model
      include Assault::Alive
    end
  end

  let(:injured_object) { subject.new health_points: 1, max_health_points: 3 }
  let(:dead_object) { subject.new health_points: 0, max_health_points: 3 }
  let(:full_life_object) { subject.new health_points: 4, max_health_points: 4 }

  it 'has health points' do
    expect(subject.new).to respond_to(:health_points)
  end

  it 'has max health points' do
    expect(subject.new).to respond_to(:max_health_points)
  end

  describe '#alive/damaged/dead & aliases' do
    it 'forwards working? to alive?' do
      expect(full_life_object.method(:working?)).to eq full_life_object.method(:alive?)
    end

    it 'forwards destroyed? to dead?' do
      expect(full_life_object.method(:destroyed?)).to eq full_life_object.method(:dead?)
    end

    it 'forwards damaged? to injured?' do
      expect(full_life_object.method(:damaged?)).to eq full_life_object.method(:injured?)
    end

    it 'is alive' do
      expect(injured_object).to be_alive
      expect(dead_object).not_to be_alive
    end

    it 'is injured' do
      expect(injured_object).to be_injured
      expect(full_life_object).not_to be_injured
    end

    it 'is full_live' do
      expect(full_life_object).to be_full_life
      expect(injured_object).not_to be_full_life
    end

    it 'is dead' do
      expect(dead_object).to be_dead
      expect(injured_object).not_to be_dead
    end
  end

  describe '#heal/repair' do
    it 'forwards repair to heal method' do
      expect(injured_object.method(:repair)).to eq injured_object.method(:heal)
    end

    it 'can heal living things' do
      expect { injured_object.heal(1) }.to change(injured_object, :health_points).by(1)
    end

    it 'cannot over heal things' do
      expect { injured_object.heal(3) }.to change(injured_object, :health_points).by(2)
    end

    it 'cannot heal dead things' do
      expect { dead_object.heal(1) }.not_to change(dead_object, :health_points)
    end

    it 'returns healed value' do
      expect(injured_object.heal(2)).to eq 2
    end

    it 'returns only healed value when over heal' do
      expect(injured_object.heal(5)).to eq 2
    end

    it 'returns 0 when dead' do
      expect(dead_object.heal(5)).to eq 0
    end

    it 'returns 0 when full life' do
      expect(full_life_object.heal(2)).to eq 0
    end
  end

  describe '#injure/damage' do
    it 'forwards repair to heal method' do
      expect(injured_object.method(:injure)).to eq injured_object.method(:damage)
    end

    it 'can injure' do
      expect { injured_object.injure(1) }.to change(injured_object, :health_points).by(-1)
    end

    it 'cannot over hurt' do
      expect { injured_object.injure(2) }.to change(injured_object, :health_points).by(-1)
    end

    it 'returns damage value' do
      expect(full_life_object.injure(3)).to eq 3
    end

    it 'returns real damage and not over damage' do
      expect(full_life_object.injure(10)).to eq 4
    end

    it 'returns 0 when injuring dead things' do
      expect(dead_object.injure(2)).to eq 0
    end
  end
end
