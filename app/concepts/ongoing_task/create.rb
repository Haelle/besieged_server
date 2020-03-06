class OngoingTask
  class Create < Trailblazer::Operation
    step :find_klass
    fail :set_error_klass_not_found, fail_fast: true
    step :build_task
    step :save
    fail :forward_errors

    def find_klass(ctx, configuration:, **)
      ctx[:klass] = configuration[:type]&.constantize
    rescue NameError
      false
    end

    def build_task(ctx, klass:, configuration:, taskable:, **)
      ctx[:ongoing_task] = klass.new(
        taskable: taskable,
        params: configuration[:params],
        action_points_required: configuration[:action_points_required].to_i,
        repeatable: configuration[:repeatable]
      )
    end

    def save(_, ongoing_task:, **)
      ongoing_task.save
    end

    def set_error_klass_not_found(ctx, configuration:, **)
      ctx[:error] = "#{configuration[:type] || 'nil'} is not a class"
    end

    def forward_errors(ctx, ongoing_task:, **)
      ctx[:ongoing_task] = nil
      ctx[:error] = ongoing_task.errors.to_a.join ', '
    end
  end
end
