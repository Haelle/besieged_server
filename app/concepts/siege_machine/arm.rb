class SiegeMachine
  class Arm < Trailblazer::Operation
    step :prepare_to_fire
    step :belong_to_same_camp?
    fail :error_does_not_belong
    step :arm

    def prepare_to_fire(ctx, siege_machine:, **)
      ctx[:camp] = siege_machine.camp
      ctx[:castle] = siege_machine.camp.castle
    end

    def belong_to_same_camp?(_, camp:, character:, **)
      camp == character.camp
    end

    def arm(_, siege_machine:, castle:, **)
      castle.health_points -= siege_machine.damages
      castle.health_points = 0 if castle.health_points <= 0
      castle.save
    end

    def error_does_not_belong(ctx, siege_machine:, character:, camp:, **)
      ctx[:error] = "character (#{character.id}) does not belong to the camp (#{camp.id}) of this weapon (#{siege_machine.id})"
    end
  end
end
