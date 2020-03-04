class CharacterBlueprint < Blueprinter::Base
  identifier :id
  fields :pseudonym, :camp_id, :action_points, :max_action_points, :action_point_regeneration_rate
end
