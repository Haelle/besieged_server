class Building
  class Create < Trailblazer::Operation
    step :setup_configuration
    fail :set_error_type_not_found
    step :build
    step :set_ongoing_task_create_params
    step Subprocess OngoingTask::CreateMany
    step :save
    fail :clear_data

    def setup_configuration(ctx, building_type:, **)
      ctx[:config] = Rails
        .configuration
        .buildings[building_type.to_sym]
    end

    def build(ctx, camp:, building_type:, **)
      ctx[:erected_building] = Building.new(
        camp: camp,
        building_type: building_type
      )
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

    def set_error_type_not_found(ctx, building_type:, **)
      ctx[:error] = "#{building_type} type is not found"
    end
  end
end
