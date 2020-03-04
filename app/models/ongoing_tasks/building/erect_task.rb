class OngoingTasks::Building::ErectTask < OngoingTask
  has_paper_trail

  def camp
    @camp ||= building.camp
  end

  def target
    @erected_building
  end

  def on_completion_callback
    operation = Building::Create.call(camp: camp, building_type: params['building_type'])

    if operation.success?
      @erected_building = operation[:erected_building]
    else
      @error = operation[:error]
    end

    operation.success?
  end
end
