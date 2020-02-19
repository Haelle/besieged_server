module SetModelFromIds
  extend ActiveSupport::Concern

  # It tries to find the model's id from the params
  # first from params(:xxx_id) (if not in the model's controller)
  # then form params(:id) (if inside model's controller)
  #
  # No side effects detected

  def set_camp
    id = params[:camp_id] || params[:id]
    @camp ||= Camp.find id
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'camp not found' }, status: :not_found
  end

  def set_character
    id = params[:character_id] || params[:id]
    @character = Character.find id
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'character not found' }, status: :not_found
  end

  def set_siege_machine
    id = params[:siege_machine_id] || params[:id]
    @siege_machine = SiegeMachine.find id
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'siege machine not found' }, status: :not_found
  end
end
