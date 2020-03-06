class CastlesController < ApplicationController
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
  rescue ActiveRecord::RecordNotFound
    render json: { error: $ERROR_INFO.message }, status: :not_found
  end
end
