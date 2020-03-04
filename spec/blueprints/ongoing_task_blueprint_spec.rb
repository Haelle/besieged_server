require 'rails_helper'

RSpec.describe OngoingTaskBlueprint do
  it 'renders one ongoing task' do
    json = described_class.render(create(:arm_task))
    expect(json).to match_json_schema 'ongoing_task'
  end

  it 'renders many ongoing_tasks' do
    json = described_class.render(create_list(:arm_task, 5))
    expect(json).to match_json_schema 'ongoing_tasks'
  end
end
