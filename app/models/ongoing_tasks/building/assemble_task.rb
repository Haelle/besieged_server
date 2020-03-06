class OngoingTasks::Building::AssembleTask < OngoingTask
  def target
    @assembled_siege_machine
  end

  def camp
    building.camp
  end

  def on_completion_callback
    operation = SiegeMachine::Create
      .call(camp: camp, type: params['type'])

    if operation.success?
      @assembled_siege_machine = operation[:assembled_siege_machine]
    else
      @error = operation[:error]
    end

    operation.success?
  end
end
