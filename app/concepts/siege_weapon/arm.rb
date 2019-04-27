class SiegeWeapon
  class Arm < Trailblazer::Operation
    step :prepare_to_fire
    step :belong_to_same_camp?
    fail :error_do_not_belong
    step :arm
    step :set_action_result

    def prepare_to_fire(ctx, siege_weapon:, **)
      ctx[:camp] = siege_weapon.camp
      ctx[:castle] = siege_weapon.camp.castle
    end

    def belong_to_same_camp?(_, camp:, character:, **)
      camp == character.camp
    end

    def arm(_, siege_weapon:, castle:, **)
      castle.health_points -= siege_weapon.damage
      castle.save
    end

    def set_action_result(ctx, siege_weapon:, **)
      ctx[:action_result] = { damages: siege_weapon.damage }
    end

    def error_do_not_belong(ctx, siege_weapon:, character:, camp:, **)
      ctx[:error] = "character (#{character.id}) does not belongs to the camp (#{camp.id}) of this weapon (#{siege_weapon.id})"
    end
  end
end
