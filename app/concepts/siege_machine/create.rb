class SiegeMachine
  class Create < Trailblazer::Operation
    step :build
    step :save

    DEFAULT_SYLLABLES_COUNT = 3

    def build(ctx, camp:, siege_machine_type:, **)
      ctx[:siege_machine] = SiegeMachine.new(
        camp: camp,
        siege_machine_type: siege_machine_type,
        damages: random_damages,
        name: random_name
      )
    end

    def save(_, siege_machine:, **)
      siege_machine.save
    end

    private

    def random_damages
      [*1..10].sample * 10
    end

    def random_name
      generator = ::NameGenerator::Main.new
      generator.next_name DEFAULT_SYLLABLES_COUNT
    end
  end
end
