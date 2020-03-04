require 'rails_helper'

RSpec.describe OngoingTaskResultBlueprint do
  it 'renders one ongoing task completed result' do
    task = create :arm_task
    task_result = trb_result_success_with(
      ongoing_task: task,
      ongoing_task_status: 'completed',
      target: task.siege_machine.camp.castle
    )

    json = described_class.render(task_result)
    expect(json).to match_json_schema 'ongoing_task_result_completed'
  end

  it 'renders one ongoing task ongoing result' do
    task = create :arm_task
    task_result = trb_result_success_with(
      ongoing_task: task,
      ongoing_task_status: 'ongoing'
    )

    json = described_class.render(task_result)
    expect(json).to match_json_schema 'ongoing_task_result_still_ongoing'
  end
end
