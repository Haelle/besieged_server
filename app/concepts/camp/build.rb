require 'name_generator'

class Camp
  class Build < Trailblazer::Operation
    step :setup_context
    step :belong_to_same_camp?
    fail :error_does_not_belong
    step Subprocess Character::Operate
    step :set_results

    DEFAULT_SYLLABLES_COUNT = 3

    def setup_context(ctx, camp:, siege_machine_type:, **)
      ctx[:action_type] = 'build'
      ctx[:params] = { siege_machine_type: siege_machine_type }
      ctx[:target] = camp
      ctx[:callback] = method :build_callback
    end

    def belong_to_same_camp?(_, camp:, character:, **)
      camp == character.camp
    end

    def set_results(ctx, **)
      ctx[:siege_machine] = @new_machine
      ctx[:status] = 'built'
    end

    def error_does_not_belong(ctx, camp:, character:, **)
      ctx[:error] = "character (#{character.id}) does not belong to the camp (#{camp.id})"
    end

    private

    def build_callback(camp, _params)
      # TODO: SiegeMachineFactory.create :catapult ?
      @new_machine = SiegeMachine.create camp: camp, damages: random_damages, name: random_name
    end

    def random_damages
      [*1..10].sample * 10
    end

    def random_name
      generator = ::NameGenerator::Main.new
      generator.next_name DEFAULT_SYLLABLES_COUNT
    end
  end
end
