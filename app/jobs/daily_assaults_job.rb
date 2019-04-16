class DailyAssaultsJob < ApplicationJob
  queue_as :daily_assaults

  def perform(*_)
    Castle.all.each(&:counter_attack)
  end
end
