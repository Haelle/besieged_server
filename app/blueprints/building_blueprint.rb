class BuildingBlueprint < Blueprinter::Base
  identifier :id
  fields :type, :camp_id

  association :ongoing_tasks, blueprint: OngoingTaskBlueprint
end
