class SiegeMachineBlueprint < Blueprinter::Base
  identifier :id
  fields :damages, :name, :camp_id

  association :ongoing_tasks, blueprint: OngoingTaskBlueprint
end
