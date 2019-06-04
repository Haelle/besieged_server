class CharactersController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_camp,                         only: %i[index_by_camp join]
  before_action :set_character,                    only: %i[show]
  before_action :authorize_action_only_to_itself!, only: %i[show]

  # GET /camps/1/characters
  def index_by_camp
    @characters = @camp.characters

    render json: CharacterBlueprint.render(@characters)
  end

  # GET /accounts/1/characters
  def index_by_account
    @characters = Character.where account: found_account

    render json: CharacterBlueprint.render(@characters)
  end

  # GET /characters/1
  def show
    render json: CharacterBlueprint.render(@character)
  end

  # POST /camps/1/characters/join
  def join
    if joining.success?
      render json: CharacterBlueprint.render(joining[:action_result][:character])
    else
      render json: { error: joining[:error] }, status: :unprocessable_entity
    end
  end

  private

  def set_camp
    @camp ||= Camp.find params[:camp_id]
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'camp not found' }, status: :not_found
  end

  def set_character
    @character = Character.find params[:id]
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'character not found' }, status: :not_found
  end

  def joining
    @joining ||= Camp::Join.call account: found_account, camp: @camp, pseudonyme: params[:pseudonyme]
  end
end
