class Character
  class RegenerateActionPoints < Trailblazer::Operation
    step :compute_new_value
    step :update

    def compute_new_value(ctx, character:, **)
      increased_value = character.action_points + character.action_point_regeneration_rate

      ctx[:action_points] = [
        increased_value,
        character.max_action_points
      ].min
    end

    def update(_, character:, action_points:, **)
      character.update(action_points: action_points)
    end
  end
end
