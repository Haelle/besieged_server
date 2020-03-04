class BuildingsController < ApplicationController
  include SetModelFromIds

  before_action :authorize_access_request!
  before_action :set_building, only: %i[show]
  before_action :set_camp, only: %i[index]

  # GET /camps/1/buildings
  def index
    @buildings = @camp.buildings

    render json: BuildingBlueprint.render(@buildings)
  end

  # GET /buildings/1
  def show
    render json: BuildingBlueprint.render(@building)
  end
end
