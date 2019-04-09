class Resources::CastlesController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_castle, only: %i[show update destroy]

  # GET /castles
  def index
    @castles = Castle.all

    render json: @castles
  end

  # GET /castles/1
  def show
    render json: @castle
  end

  # POST /castles
  def create
    @castle = Castle.new(castle_params)

    if @castle.save
      render json: @castle, status: :created, location: @castle
    else
      render json: @castle.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /castles/1
  def update
    if @castle.update(castle_params)
      render json: @castle
    else
      render json: @castle.errors, status: :unprocessable_entity
    end
  end

  # DELETE /castles/1
  def destroy
    @castle.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_castle
    @castle = Castle.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def castle_params
    params.require(:castle).permit(:health_points, :camp_id)
  end
end
