require 'rails_helper'

RSpec.describe DailyAssaultsJob, type: :job do
  it 'is enqueued' do
    expect { described_class.perform_later }
      .to have_enqueued_job
      .on_queue('besieged_test_daily_assaults')
  end

  it 'launch counter_attack for each castle' do
    create :castle
    expect_any_instance_of(Castle).to receive(:counter_attack).once
    described_class.perform_now
  end
end
