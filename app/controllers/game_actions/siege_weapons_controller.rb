class GameActions::SiegeWeaponsController < ApplicationController
  before_action :authorize_access_request!

  # POST /arm
  def arm
    # TODO: check character belongs to account !
    siege_weapon = SiegeWeapon.find(params[:siege_weapon_id])
    character = Character.find(params[:character_id])

    arming = SiegeWeapon::Arm.call(siege_weapon: siege_weapon, character: character)

    if arming.success?
      render json: siege_weapon
    else
      render json: { error: arming[:error] }, status: :unprocessable_entity
    end

  end
end
