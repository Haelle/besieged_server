class OngoingTasks::Building::ErectTask < OngoingTask
  def camp
    @camp ||= building.camp
  end

  def target
    @erected_building
  end

  def on_completion_callback
    operation = Building::Create.call(camp: camp, type: params['type'])

    if operation.success?
      @erected_building = operation[:erected_building]
    else
      @error = operation[:error]
    end

    operation.success?
  end
end
