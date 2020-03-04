RSpec.shared_examples 'continuing ongoing task by one point' do
  it 'continues ongoing task' do
    expect { subject; ongoing_task.reload }.to change(ongoing_task, :action_points_spent).by 1
  end
end
