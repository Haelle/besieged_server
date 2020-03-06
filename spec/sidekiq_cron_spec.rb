require 'rails_helper'

RSpec.describe 'Sidekiq job schedule' do
  subject { Sidekiq::Cron::Job.find name: job_name }

  before do
    quietly do
      schedule_file = 'config/schedule.yml'
      Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file) if File.exist?(schedule_file)
    end
  end

  after do
    quietly { Sidekiq::Cron::Job.destroy_all! }
  end

  let(:every_6_hours_regex) { /\d{4}-\d{2}-\d{2} (00|06|12|18):\d{2}:\d{2} \+0100/ }

  describe '#DailyAssaultJob' do
    let(:job_name) { 'daily_assaults' }

    it { is_expected.to be_valid }
    it { is_expected.to be_enabled }
    its(:klass) { is_expected.to eq 'DailyAssaultsJob' }
    its(:klass_valid) { is_expected.to be true }

    it 'is programmed every 6 hours from 00:00 in Paris time zone' do
      timestamp = subject.formated_enqueue_time.to_i
      time_in_paris = Time.zone.at timestamp
      expect(time_in_paris.to_s).to match(every_6_hours_regex)
    end
  end

  describe '#RegenerateCharacterActionPointsJob' do
    let(:job_name) { 'regenerate_action_points' }

    it { is_expected.to be_valid }
    it { is_expected.to be_enabled }
    its(:klass) { is_expected.to eq 'RegenerateCharacterActionPointsJob' }
    its(:klass_valid) { is_expected.to be true }

    it 'is programmed every 6 hours from 00:00 in Paris time zone' do
      timestamp = subject.formated_enqueue_time.to_i
      time_in_paris = Time.zone.at timestamp
      expect(time_in_paris.to_s).to match(every_6_hours_regex)
    end
  end

  def quietly
    old_log_level = Sidekiq.logger.level
    Sidekiq.logger.level = Logger::ERROR

    yield

    Sidekiq.logger.level = old_log_level
  end
end
