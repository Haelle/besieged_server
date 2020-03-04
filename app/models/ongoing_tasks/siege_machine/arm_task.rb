class OngoingTasks::SiegeMachine::ArmTask < OngoingTask
  def camp
    @camp ||= siege_machine.camp
  end

  def target
    @target ||= camp.castle
  end
  alias castle target

  def on_completion_callback
    castle.lock!

    castle.health_points -= siege_machine.damages
    castle.health_points = 0 if castle.health_points <= 0

    is_saved = castle.save
    set_error unless is_saved
    is_saved
  end

  private

  def set_error
    @error = 'Failed to fire upon the castle'
  end
end
