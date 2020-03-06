class CampsController < ApplicationController
  include SetModelFromIds

  before_action :authorize_access_request!
  before_action :set_camp, only: %i[show join]

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
      render json: { error: joining[:error] }, status: :bad_request
    end
  end

  private

  def joining
    @joining ||= Camp::Join.call(
      account: found_account,
      camp: @camp,
      pseudonym: params[:pseudonym]
    )
  end
end
