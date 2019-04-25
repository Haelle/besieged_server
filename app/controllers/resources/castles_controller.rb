class Resources::CastlesController < ApplicationController
  before_action :authorize_access_request!

  # GET /castles
  def index
    @castles = Castle.all

    render json: CastleBlueprint.render(@castles)
  end

  # GET /castles/1
  def show
    @castle = Castle.find(params[:id])
    render json: CastleBlueprint.render(@castle)
  end
end
