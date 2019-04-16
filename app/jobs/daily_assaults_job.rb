class DailyAssaultsJob < ApplicationJob
  queue_as :daily_assaults

  def perform
    Castle.all.each(&:counter_attack)
  end
end
