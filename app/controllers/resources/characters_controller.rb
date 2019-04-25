class Resources::CharactersController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_character,                    only: %i[show]
  before_action :authorize_action_only_to_itself!, only: %i[show]

  # GET /characters
  def index
    @characters = Character.where account: found_account

    render json: CharacterBlueprint.render(@characters)
  end

  # GET /characters/1
  def show
    render json: CharacterBlueprint.render(@character)
  end

  private

  def set_character
    @character = Character.find(params[:id])
  end

  def authorize_action_only_to_itself!
    raise Unauthorized unless @character.account == found_account
  end
end
