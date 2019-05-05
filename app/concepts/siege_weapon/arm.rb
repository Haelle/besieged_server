class SiegeWeapon
  class Arm < Trailblazer::Operation
    step :prepare_to_fire
    step :belong_to_same_camp?
    fail :error_does_not_belong
    step :arm

    def prepare_to_fire(ctx, siege_weapon:, **)
      ctx[:camp] = siege_weapon.camp
      ctx[:castle] = siege_weapon.camp.castle
    end

    def belong_to_same_camp?(_, camp:, character:, **)
      camp == character.camp
    end

    def arm(_, siege_weapon:, castle:, **)
      castle.health_points -= siege_weapon.damages
      castle.health_points = 0 if castle.health_points <= 0
      castle.save
    end

    def error_does_not_belong(ctx, siege_weapon:, character:, camp:, **)
      ctx[:error] = "character (#{character.id}) does not belong to the camp (#{camp.id}) of this weapon (#{siege_weapon.id})"
    end
  end
end
