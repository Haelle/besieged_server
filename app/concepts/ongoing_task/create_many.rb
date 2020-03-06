class OngoingTask
  class CreateMany < Trailblazer::Operation
    step :setup
    step :build_tasks
    fail :clear_tasks

    def setup(ctx, **)
      ctx[:ongoing_tasks] = []
    end

    def build_tasks(ctx, ongoing_tasks:, configurations:, taskable:, **)
      configurations.each do |config|
        create_operation = Create.call(configuration: config, taskable: taskable)
        ctx[:error] = create_operation[:error]

        return false if create_operation.failure?

        ongoing_tasks << create_operation[:ongoing_task]
      end
    end

    def clear_tasks(ctx, **)
      ctx[:ongoing_tasks] = []
    end
  end
end
