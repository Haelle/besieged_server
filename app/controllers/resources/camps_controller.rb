class Resources::CampsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_camp, only: [:show, :update, :destroy]

  # GET /camps
  def index
    @camps = Camp.all

    render json: @camps
  end

  # GET /camps/1
  def show
    render json: @camp
  end

  # POST /camps
  def create
    @camp = Camp.new(camp_params)

    if @camp.save
      render json: @camp, status: :created, location: @camp
    end
  end

  # DELETE /camps/1
  def destroy
    @camp.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_camp
      @camp = Camp.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def camp_params
      params.fetch(:camp, {})
    end
end
