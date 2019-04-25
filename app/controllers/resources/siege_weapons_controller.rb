class Resources::SiegeWeaponsController < ApplicationController
  before_action :authorize_access_request!

  # GET /siege_weapons
  def index
    @siege_weapons = SiegeWeapon.all

    render json: SiegeWeaponBlueprint.render(@siege_weapons)
  end

  # GET /siege_weapons/1
  def show
    @siege_weapon = SiegeWeapon.find(params[:id])

    render json: SiegeWeaponBlueprint.render(@siege_weapon)
  end
end
