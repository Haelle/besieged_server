class OngoingTask
  module Task
    class PreChecksForTransaction < Trailblazer::Operation
      step :character_belongs_to_same_camp?
      fail :set_error_does_not_belong_to_this_camp, fail_fast: true
      step :character_should_not_be_exhausted?
      fail :set_error_character_exhausted, fail_fast: true
      step :already_completed_unique_task?
      fail :set_error_taks_already_completed

      def character_belongs_to_same_camp?(_, character:, ongoing_task:, **)
        character.camp == ongoing_task.camp
      end

      def character_should_not_be_exhausted?(_, character:, **)
        !character.exhausted?
      end

      def already_completed_unique_task?(_, ongoing_task:, **)
        !ongoing_task.completed? || ongoing_task.repeatable
      end

      def set_error_does_not_belong_to_this_camp(ctx, character:, **)
        ctx[:error] = "#{character.pseudonym} does not belong to this camp"
      end

      def set_error_character_exhausted(ctx, character:, **)
        ctx[:error] = "#{character.pseudonym} is exhausted, wait to get more points"
      end

      def set_error_taks_already_completed(ctx, **)
        ctx[:error] = 'This task is already completed and not repeatable'
      end
    end
  end
end
