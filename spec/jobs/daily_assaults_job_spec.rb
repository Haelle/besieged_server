require 'rails_helper'

RSpec.describe DailyAssaultsJob, type: :job do
  it 'is enqueued' do
    expect { described_class.perform_later }
      .to have_enqueued_job
      .on_queue('shared_world_test_daily_assaults')
  end
end
