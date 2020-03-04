class OngoingTask
  module Task
    class ActionPointsTransaction < Trailblazer::Operation
      step :decrement_character_points
      fail :set_error_decrement, fail_fast: true
      step :increment_ongoing_task_points
      fail :set_error_increment

      def decrement_character_points(_, character:, **)
        character.action_points -= 1
        character.save
      end

      def increment_ongoing_task_points(_, ongoing_task:, **)
        ongoing_task.action_points_spent += 1
        ongoing_task.save
      end

      def set_error_decrement(ctx, character:, **)
        ctx[:error] = "Faild to decrement character: #{character.errors.messages}"
      end

      def set_error_increment(ctx, ongoing_task:, **)
        ctx[:error] = "Failed to increment ongoing task: #{ongoing_task.errors.messages}"
      end
    end
  end
end
