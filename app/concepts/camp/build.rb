class Camp
  class Build < Trailblazer::Operation
    include OperationHelper

    step :setup_context
    step :belong_to_same_camp?
    fail :error_does_not_belong
    step Subprocess Character::Operate
    step :set_results

    def setup_context(ctx, camp:, siege_machine_type:, **)
      ctx[:action_type] = 'build'
      ctx[:params] = { siege_machine_type: siege_machine_type }
      ctx[:target] = camp
      ctx[:callback] = method :build_callback
    end

    def set_results(ctx, **)
      ctx[:siege_machine] = @new_machine
      ctx[:status] = 'built'
    end

    private

    def build_callback(camp, params)
      operation = SiegeMachine::Create.call(camp: camp, siege_machine_type: params[:siege_machine_type])

      @new_machine = operation[:siege_machine] if operation.success?

      operation.success?
    end
  end
end
