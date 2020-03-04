class OngoingTasksController < ApplicationController
  include SetModelFromIds

  before_action :authorize_access_request!
  before_action :set_ongoing_task, only: %i[show continue]
  before_action :set_character, only: %i[continue]
  before_action :authorize_action_only_to_itself!, only: %i[continue]

  # GET /buildings/:id/ongoing_tasks
  # GET /siege_machines/:id/ongoing_tasks
  def index
    find_ongoing_tasks
    render json: OngoingTaskBlueprint.render(@ongoing_tasks)
  rescue ActiveRecord::RecordNotFound
    render json: { error: $ERROR_INFO.message }, status: :not_found
  end

  # GET /ongoing_tasks/1
  def show
    render json: OngoingTaskBlueprint.render(@ongoing_task)
  end

  # POST /ongoing_tasks/1/(continue|erect|assemble|arm)
  def continue
    if continuing.success?
      render json: OngoingTaskResultBlueprint.render(continuing)
    else
      render json: { error: continuing[:error] }, status: :bad_request
    end
  end

  private

  def continuing
    @continuing ||= OngoingTask::Continue.call(ongoing_task: @ongoing_task, character: @character)
  end

  def find_ongoing_tasks
    if params[:building_id]
      building = Building.find params[:building_id]
      @ongoing_tasks = building.ongoing_tasks
    elsif params[:siege_machine_id]
      @ongoing_tasks = SiegeMachine
        .find(params[:siege_machine_id])
        .ongoing_tasks
    end
  end
end
