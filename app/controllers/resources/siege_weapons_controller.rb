class Resources::SiegeWeaponsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_siege_weapon, only: %i[show update destroy]

  # GET /siege_weapons
  def index
    @siege_weapons = SiegeWeapon.all

    render json: @siege_weapons
  end

  # GET /siege_weapons/1
  def show
    render json: @siege_weapon
  end

  # POST /siege_weapons
  def create
    @siege_weapon = SiegeWeapon.new(siege_weapon_params)

    if @siege_weapon.save
      render json: @siege_weapon, status: :created, location: @siege_weapon
    else
      render json: @siege_weapon.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /siege_weapons/1
  def update
    if @siege_weapon.update(siege_weapon_params)
      render json: @siege_weapon
    else
      render json: @siege_weapon.errors, status: :unprocessable_entity
    end
  end

  # DELETE /siege_weapons/1
  def destroy
    @siege_weapon.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_siege_weapon
    @siege_weapon = SiegeWeapon.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def siege_weapon_params
    params.require(:siege_weapon).permit(:damage, :camp_id)
  end
end
