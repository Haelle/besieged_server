class GameActions::SiegeWeaponsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_siege_weapon
  before_action :set_character
  before_action :authorize_action_only_to_itself!

  # POST /arm
  def arm
    arming = SiegeWeapon::Arm.call(siege_weapon: @siege_weapon, character: @character)

    if arming.success?
      weapon_hash = SiegeWeaponBlueprint.render_as_hash arming[:action_result][:siege_weapon]
      castle_hash = CastleBlueprint.render_as_hash      arming[:action_result][:castle]
      render json: { siege_weapon: weapon_hash, castle: castle_hash }
    else
      render json: { error: arming[:error] }, status: :unprocessable_entity
    end
  end

  private

  def set_siege_weapon
    @siege_weapon = SiegeWeapon.find(params[:siege_weapon_id])
  end

  def set_character
    @character = Character.find params[:character_id]
  end
end
