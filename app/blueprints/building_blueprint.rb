class BuildingBlueprint < Blueprinter::Base
  identifier :id
  fields :building_type, :camp_id

  association :ongoing_tasks, blueprint: OngoingTaskBlueprint
end
