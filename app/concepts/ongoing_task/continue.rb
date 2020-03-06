class OngoingTask
  class Continue < Trailblazer::Operation
    step Wrap(WithinTransaction) {
      step :lock_resources
      step Subprocess Task::PreChecksForTransaction
      step Subprocess Task::ActionPointsTransaction
      step Subprocess Task::ExecuteCompletionCallback
    }

    def lock_resources(_, character:, ongoing_task:, **)
      character.lock!
      ongoing_task.lock!
    end
  end
end
