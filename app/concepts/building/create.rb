class Building
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

    def setup_configuration(ctx, snake_type:, **)
      ctx[:config] = Rails
        .configuration
        .buildings[snake_type.to_sym]
    end

    def build(ctx, camp:, klass:, **)
      ctx[:erected_building] = klass.new(camp: camp)
    end

    def set_ongoing_task_create_params(ctx, erected_building:, config:, **)
      ctx[:taskable] = erected_building
      ctx[:configurations] = config[:ongoing_tasks]
    end

    def save(_, erected_building:, **)
      erected_building.save
    end

    def clear_data(ctx, **)
      ctx[:erected_building] = nil
    end

    def set_error_type_not_found(ctx, type:, **)
      ctx[:error] = "#{type} type is not found"
    end
  end
end
