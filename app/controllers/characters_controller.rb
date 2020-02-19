class CharactersController < ApplicationController
  include SetModelFromIds

  before_action :authorize_access_request!
  before_action :set_character,                    only: %i[show]
  before_action :authorize_action_only_to_itself!, only: %i[show]

  # GET /camps/1/characters
  # GET /accounts/1/characters
  def index
    if params[:camp_id]
      camp = Camp.find params[:camp_id]
      characters = camp.characters
    else
      characters = Character.where account: found_account
    end

    render json: CharacterBlueprint.render(characters)
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'camp not found' }, status: :not_found
  end

  # GET /characters/1
  def show
    render json: CharacterBlueprint.render(@character)
  end
end
