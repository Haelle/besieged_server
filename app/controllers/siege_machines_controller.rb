class SiegeMachinesController < ApplicationController
  include SetModelFromIds

  before_action :authorize_access_request!
  before_action :set_camp, only: %i[index]
  before_action :set_siege_machine, only: %i[show]

  # GET /camps/1/siege_machines
  def index
    @siege_machines = @camp.siege_machines

    render json: SiegeMachineBlueprint.render(@siege_machines)
  end

  # GET /siege_machines/2
  def show
    render json: SiegeMachineBlueprint.render(@siege_machine)
  end
end
