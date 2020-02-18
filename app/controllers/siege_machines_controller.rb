class SiegeMachinesController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_camp
  before_action :set_character, only: %i[arm build]
  before_action :set_siege_machine, only: %i[arm]
  before_action :authorize_action_only_to_itself!, only: %i[arm build]

  # GET /camps/1/siege_machines
  def index
    @siege_machines = @camp.siege_machines

    render json: SiegeMachineBlueprint.render(@siege_machines)
  end

  # GET /camps/1/siege_machines/2
  def show
    @siege_machine = @camp.siege_machines.find params[:id]

    render json: SiegeMachineBlueprint.render(@siege_machine)
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'siege weapon not found' }, status: :not_found
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

  # POST /camps/1/siege_machines/build
  def build
    @operation_result = building
    if @operation_result.success?
      render json: {
        camp: camp_hash,
        siege_machine: weapon_hash,
        status: @operation_result[:status]
      }
    else
      render json: { error: @operation_result[:error] }, status: :unprocessable_entity
    end
  end

  private

  def set_camp
    @camp = Camp.find params[:camp_id]
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'camp not found' }, status: :not_found
  end

  def set_character
    @character = @camp.characters.find params[:character_id]
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'character not found' }, status: :not_found
  end

  def set_siege_machine
    @siege_machine = @camp.siege_machines.find params[:id]
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'siege weapon not found' }, status: :not_found
  end

  def arming
    @arming ||= SiegeMachine::Arm.call(siege_machine: @siege_machine, character: @character)
  end

  def building
    @building ||= SiegeMachine::Build.call(camp: @camp, character: @character)
  end

  def camp_hash
    CampBlueprint.render_as_hash @operation_result[:camp]
  end

  def castle_hash
    CastleBlueprint.render_as_hash @operation_result[:castle]
  end

  def weapon_hash
    SiegeMachineBlueprint.render_as_hash @operation_result[:siege_machine]
  end
end
