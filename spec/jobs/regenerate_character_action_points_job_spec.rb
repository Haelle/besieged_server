require 'rails_helper'

RSpec.describe RegenerateCharacterActionPointsJob, type: :job do
  subject { described_class.perform_now }

  let!(:character) { create :character }

  it 'is enqueued to regenerate action points' do
    expect { described_class.perform_later }
      .to have_enqueued_job
      .on_queue('besieged_test_regenerate_action_points')
  end

  it 'regenerate all characters action points' do
    create_list :character, 3
    receive_count = 0

    allow(Character::RegenerateActionPoints)
      .to receive(:call) { receive_count += 1 }

    subject
    expect(receive_count).to eq 4
  end

  it 'effectivly regenerate character action points' do
    expect { subject; character.reload }.to change(character, :action_points)
  end

  it 'locks the characters before updating them' do
    expect_any_instance_of(Character).to receive(:with_lock)
    subject
  end
end
