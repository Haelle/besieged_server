class OngoingTask
  module Task
    class ExecuteCompletionCallback < Trailblazer::Operation
      step :completed?
      fail :set_status_ongoing, Output(:success) => End(:success)
      step :execute_callback
      step :forward_target
      step :reset_if_repeatable
      step :set_status_completed
      fail :forwards_error

      def completed?(_, ongoing_task:, **)
        ongoing_task.completed?
      end

      def set_status_ongoing(ctx, **)
        ctx[:ongoing_task_status] = 'ongoing'
      end

      def set_status_completed(ctx, **)
        ctx[:ongoing_task_status] = 'completed'
      end

      def execute_callback(_, ongoing_task:, **)
        ongoing_task.on_completion_callback
      end

      def forward_target(ctx, ongoing_task:, **)
        ctx[:target] = ongoing_task.target
      end

      def reset_if_repeatable(_, ongoing_task:, **)
        if ongoing_task.repeatable
          ongoing_task.update action_points_spent: 0
        else
          true
        end
      end

      def forwards_error(ctx, ongoing_task:, **)
        ctx[:error] = ongoing_task.error
      end
    end
  end
end
