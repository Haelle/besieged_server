class CampsController < ApplicationController
  include OperationResultToHash
  include SetModelFromIds

  before_action :authorize_access_request!
  before_action :set_camp, only: %i[show join build]
  before_action :set_character, only: %i[build]
  before_action :authorize_action_only_to_itself!, only: %i[build]

  # GET /camps
  def index
    @camps = Camp.all

    render json: CampBlueprint.render(@camps)
  end

  # GET /camps/1
  def show
    render json: CampBlueprint.render(@camp)
  end

  # POST /camps/1/join
  def join
    if joining.success?
      render json: CharacterBlueprint.render(joining[:action_result][:character])
    else
      render json: { error: joining[:error] }, status: :unprocessable_entity
    end
  end

  # POST /camps/1/build
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

  def building
    @building ||= SiegeMachine::Build.call(camp: @camp, character: @character)
  end

  def joining
    @joining ||= Camp::Join.call(
      account: found_account,
      camp: @camp,
      pseudonyme: params[:pseudonyme]
    )
  end
end
