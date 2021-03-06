class SiegeMachine
  class Create < Trailblazer::Operation
    include CreateHelper

    step :find_klass
    step :type_to_snake_case
    step :setup_configuration
    fail :set_error_type_not_found
    step :build
    step :set_ongoing_task_create_params
    step Subprocess OngoingTask::CreateMany
    step :save
    fail :clear_data

    DEFAULT_SYLLABLES_COUNT = 3

    def setup_configuration(ctx, snake_type:, **)
      ctx[:config] = Rails
        .configuration
        .siege_machines[snake_type]
    end

    def build(ctx, camp:, klass:, config:, **)
      ctx[:assembled_siege_machine] = klass.new(
        camp: camp,
        damages: random_damages(config),
        position: klass.next_position_vacancy(camp),
        name: random_name
      )
    end

    def set_ongoing_task_create_params(ctx, assembled_siege_machine:, config:, **)
      ctx[:taskable] = assembled_siege_machine
      ctx[:configurations] = config[:ongoing_tasks]
    end

    def save(_, assembled_siege_machine:, **)
      assembled_siege_machine.save
    end

    def clear_data(ctx, **)
      ctx[:assembled_siege_machine] = nil
    end

    def set_error_type_not_found(ctx, type:, **)
      ctx[:error] = "#{type} type is not found"
    end

    private

    def random_damages(config)
      random_range(config)
        .to_a
        .sample
    end

    def random_range(config)
      (config[:minimum_damages]..config[:maximum_damages])
        .step(config[:step_damages])
    end

    def random_name
      generator = ::NameGenerator::Main.new
      generator.next_name DEFAULT_SYLLABLES_COUNT
    end
  end
end
