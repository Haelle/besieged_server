class Resources::CharactersController < ApplicationController
  before_action :authorize_access_request!

  # GET /characters
  def index
    @characters = Character.all

    render json: @characters
  end

  # GET /characters/1
  def show
    @character = Character.find(params[:id])
    render json: @character
  end
end
