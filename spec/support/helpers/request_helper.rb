module RequestHelper
  def erect_workshop_task
    camp
      .toc
      .ongoing_tasks
      .find { |t| t.params['type'] == 'Buildings::SiegeMachineWorkshop' }
  end

  def assemble_task_of(machine_type)
    workshop
      .ongoing_tasks
      .find { |t| t.params['type'] == machine_type.name }
  end

  def arm_task_of(machine_type)
    get_siege_machine_type(machine_type)
      .first
      .ongoing_tasks
      .find { |t| t.is_a? OngoingTasks::SiegeMachine::ArmTask }
  end

  def workshop
    camp
      .reload
      .buildings
      .find { |b| b.is_a? Buildings::SiegeMachineWorkshop }
  end

  def get_siege_machine_type(machine_type)
    camp
      .siege_machines
      .select { |m| m.is_a? machine_type }
  end

  def catapults
    get_siege_machine_type SiegeMachines::Catapult
  end

  def catapult
    catapults.first
  end

  def complete_task(ongoing_task)
    ongoing_task.update(action_points_required: 3)

    loop do
      ongoing_task.reload
      character.reload

      Character::RegenerateActionPoints.call(character: character) if character.exhausted?

      post "/ongoing_tasks/#{ongoing_task.id}/continue", params: { character_id: character.id }, headers: headers
      expect(response).to have_http_status :ok

      break if response_json[:status] == 'completed'
    end

    camp.reload
    castle.reload
  end
end
