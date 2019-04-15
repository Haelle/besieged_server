class DailyAssaultsJob < ApplicationJob
  queue_as :daily_assaults

  def perform(*args)
    # Do something later
  end
end
