class GameActions::CampsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_camp

  # POST /join
  def join
    pseudo = params[:pseudonyme]
    joining = Camp::Join.call(account: found_account, camp: @camp, pseudonyme: pseudo)

    if joining.success?
      render json: CharacterBlueprint.render(joining[:action_result][:character])
    else
      render json: { error: joining[:error] }, status: :unprocessable_entity
    end
  end

  private

  def set_camp
    @camp = Camp.find params[:camp_id]
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'camp not found' }, status: :not_found
  end
end
