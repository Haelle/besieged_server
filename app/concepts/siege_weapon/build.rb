class SiegeWeapon
  class Build < Trailblazer::Operation
    step :belong_to_same_camp?
    fail :error_does_not_belong
    step :build
    step :set_results

    def belong_to_same_camp?(_, camp:, character:, **)
      camp == character.camp
    end

    def build(ctx, camp:, **)
      ctx[:siege_weapon] = SiegeWeapon.new camp: camp, damages: random_damages
      ctx[:siege_weapon].save && camp.reload
    end

    def set_results(ctx, **)
      ctx[:status] = 'built'
    end

    def error_does_not_belong(ctx, camp:, character:, **)
      ctx[:error] = "character (#{character.id}) does not belong to the camp (#{camp.id})"
    end

    private

    def random_damages
      [*1..10].sample * 10
    end
  end
end
