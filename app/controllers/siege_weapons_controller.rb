class SiegeWeaponsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_camp
  before_action :set_character, only: %i[arm build]
  before_action :set_siege_weapon, only: %i[arm]
  before_action :authorize_action_only_to_itself!, only: %i[arm build]

  # GET /camps/1/siege_weapons
  def index
    @siege_weapons = @camp.siege_weapons

    render json: SiegeWeaponBlueprint.render(@siege_weapons)
  end

  # GET /camps/1/siege_weapons/2
  def show
    @siege_weapon = @camp.siege_weapons.find params[:id]

    render json: SiegeWeaponBlueprint.render(@siege_weapon)
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'siege weapon not found' }, status: :not_found
  end

  # POST camps/1/siege_weapon/2/arm
  def arm
    arming = SiegeWeapon::Arm.call(siege_weapon: @siege_weapon, character: @character)

    if arming.success?
      weapon_hash = SiegeWeaponBlueprint.render_as_hash arming[:siege_weapon]
      castle_hash = CastleBlueprint.render_as_hash      arming[:castle]
      render json: { siege_weapon: weapon_hash, castle: castle_hash }
    else
      render json: { error: arming[:error] }, status: :unprocessable_entity
    end
  end

  # POST /camps/1/siege_weapons/build
  def build
    building = SiegeWeapon::Build.call(camp: @camp, character: @character)

    if building.success?
      weapon_hash = SiegeWeaponBlueprint.render_as_hash building[:siege_weapon]
      camp_hash   = CampBlueprint.render_as_hash        building[:camp]
      render json: { camp: camp_hash, siege_weapon: weapon_hash, status: building[:status] }
    else
      render json: { error: building[:error] }, status: :unprocessable_entity
    end
  end

  private

  def set_camp
    @camp = Camp.find params[:camp_id]
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'camp not found' }, status: :not_found
  end

  def set_character
    @character = @camp.characters.find params[:character_id]
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'character not found' }, status: :not_found
  end

  def set_siege_weapon
    @siege_weapon = @camp.siege_weapons.find params[:id]
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'siege weapon not found' }, status: :not_found
  end
end
