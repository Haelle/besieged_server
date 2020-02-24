class SiegeMachine
  class Arm < Trailblazer::Operation
    include OperationHelper

    step :prepare_to_fire
    step :belong_to_same_camp?
    fail :error_does_not_belong
    step Subprocess Character::Operate

    def prepare_to_fire(ctx, siege_machine:, **)
      ctx[:camp] = siege_machine.camp
      ctx[:castle] = siege_machine.camp.castle
      ctx[:action_type] = 'arm'
      ctx[:target] = siege_machine.camp.castle
      ctx[:params] = { siege_machine: siege_machine }
      ctx[:callback] = method :arm_callback
    end

    private

    def arm_callback(castle, params)
      siege_machine = params[:siege_machine]
      castle.lock!

      castle.health_points -= siege_machine.damages
      castle.health_points = 0 if castle.health_points <= 0
      castle.save
    end
  end
end
