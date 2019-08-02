require 'rails_helper'

RSpec.describe Assault::Antagonist do
  subject do
    described_class.new(
      name: 'Name',
      tags: %i[something nothing],
      damages: 5,
      damage_range: 1..2,
      health_points: 10,
      max_health_points: 100
    )
  end

  let(:object) { Object.new }

  its(:name) { is_expected.to eq 'Name' }
  its(:tags) { are_expected.to include :something, :nothing }
  its(:damages) { are_expected.to eq 5 }
  its(:damage_range) { is_expected.to eq 1..2 }
  its(:health_points) { are_expected.to eq 10 }
  its(:max_health_points) { are_expected.to eq 100 }
end
