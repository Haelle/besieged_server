require 'rails_helper'

RSpec.describe Assault::DamageDispatcher do
  subject do
    described_class.call(
      total_damages: damages,
      damage_range: range,
      targets: targets
    )
  end

  let(:damages) { 10 }

  describe 'with 3 targets' do
    let(:targets) { build_list :citizen, 3 }
    let(:range) { 1..4 }

    it 'damages all the targets' do
      expect(targets).to all be_full_life
      subject
      expect(targets).to all be_damaged
    end

    it 'randomize targets order' do
      expect(targets).to receive(:shuffle)
        .once
        .and_call_original
      subject
    end

    it { is_expected.to eq citizen: 10 }
  end

  describe 'with one target' do
    let(:citizen) { build :citizen }
    let(:targets) { [citizen] }
    let(:range) { 1..4 }

    it 'does not damage less than expected' do
      expect(citizen).to receive(:damage)
        .at_least(3).times
        .with(a_value > 0)
        .and_call_original

      subject
      expect(citizen).to be_dead
    end

    it { is_expected.to eq citizen: 10 }
  end

  describe 'with range 4..4' do
    let(:range) { 4..4 }
    let(:stronger_citizen) { build :citizen, health_points: 11 }
    let(:targets) { [stronger_citizen] }

    it 'does not damage more than expected' do
      expect(stronger_citizen).to receive(:damage)
        .exactly(2).times
        .with(4)
        .ordered
        .and_call_original
      expect(stronger_citizen).to receive(:damage)
        .once
        .with(2)
        .ordered
        .and_call_original

      subject
      expect(stronger_citizen).to have_attributes health_points: 1
    end

    it { is_expected.to eq citizen: 10 }
  end

  describe 'with a weak team' do
    let(:baby) { build :citizen, health_points: 1 }
    let(:injured_citizen) { build :citizen, health_points: 1 }
    let(:targets) { [baby, injured_citizen] }
    let(:range) { 1..3 }

    it 'stop doing damages when everybody died' do
      expect(baby).to receive(:damage).once.and_call_original
      expect(injured_citizen). to receive(:damage).once.and_call_original
      subject
      expect(targets).to all be_dead
    end

    it { is_expected.to eq citizen: 2 }
  end

  describe 'with too many targets' do
    let(:targets) { build_list :citizen, 5 }
    let(:range) { 3..3 }

    it 'cannot injure every targets' do
      subject
      not_injured = targets.select(&:full_life?)
      expect(not_injured).not_to be_empty
    end

    it { is_expected.to eq citizen: 10 }
  end

  describe 'with high fixed range' do
    let(:damages) { 20 }
    let(:range) { 6..6 }
    let(:targets) { build_list :citizen, 2 }

    it 'leaves a survivor with due to wasted over-damages on the other one' do
      subject
      survivors = targets.select(&:alive?)
      expect(survivors).not_to be_empty
    end

    it { is_expected.to eq citizen: 18 }
  end

  it 'can be called multiple times' do
    dead_targets = build_list(:citizen, 5)
    5.times.each do
      described_class.call(
        total_damages: 10,
        targets: dead_targets,
        damage_range: 2..2
      )
    end
    expect(dead_targets).to all be_dead
  end

  context 'when targets are different classes' do
    let(:range) { 2..5 }
    let(:targets) do
      [
        build(:citizen),
        build(:palisade)
      ]
    end

    it { is_expected.to match citizen: a_value >= 2, palisade: a_value >= 2 }
  end
end
