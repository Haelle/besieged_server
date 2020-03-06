class SiegeMachineBlueprint < Blueprinter::Base
  identifier :id
  fields :type, :damages, :name, :camp_id

  association :ongoing_tasks, blueprint: OngoingTaskBlueprint
end
