class CampsController < ApplicationController
  before_action :authorize_access_request!

  # GET /camps
  def index
    @camps = Camp.all

    render json: CampBlueprint.render(@camps)
  end

  # GET /camps/1
  def show
    @camp = Camp.find(params[:id])
    render json: CampBlueprint.render(@camp)
  end
end
