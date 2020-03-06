require 'rails_helper'

RSpec.describe DailyAssaultsJob, type: :job do
  it 'is enqueued' do
    expect { described_class.perform_later }
      .to have_enqueued_job
      .on_queue('besieged_test_daily_assaults')
  end

  it 'launch counter_attack for each castle' do
    create_list :castle, 3, camp: Camp.new
    receive_count = 0

    allow_any_instance_of(Castle)
      .to receive(:counter_attack) { receive_count += 1 }

    described_class.perform_now
    expect(receive_count).to eq 3
  end
end
