class SiegeMachinesController < ApplicationController
  include OperationResultToHash
  include SetModelFromIds

  before_action :authorize_access_request!
  before_action :set_camp, only: %i[index]
  before_action :set_character, only: %i[arm]
  before_action :set_siege_machine, only: %i[show arm]
  before_action :authorize_action_only_to_itself!, only: %i[arm]

  # GET /camps/1/siege_machines
  def index
    @siege_machines = @camp.siege_machines

    render json: SiegeMachineBlueprint.render(@siege_machines)
  end

  # GET /camps/1/siege_machines/2
  def show
    render json: SiegeMachineBlueprint.render(@siege_machine)
  end

  # POST camps/1/siege_machine/2/arm
  def arm
    @operation_result = arming
    if @operation_result.success?
      render json: { siege_machine: weapon_hash, castle: castle_hash }
    else
      render json: { error: @operation_result[:error] }, status: :unprocessable_entity
    end
  end

  private

  def arming
    @arming ||= SiegeMachine::Arm.call(siege_machine: @siege_machine, character: @character)
  end
end
