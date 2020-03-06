require 'rails_helper'

RSpec.describe OngoingTasksController, type: :controller do
  it_behaves_like 'unauthorized', :get, :index, building_id: 0
  it_behaves_like 'unauthorized', :get, :index, siege_machine_id: 0
  it_behaves_like 'unauthorized', :get, :show, id: 0
  it_behaves_like 'unauthorized', :post, :continue, id: 0
  it_behaves_like 'not found', :get, :show
  it_behaves_like 'not found', :get, :index, { building_id: 'not found' }, Building
  it_behaves_like 'not found', :get, :index, { siege_machine_id: 'not found' }, SiegeMachine
  it_behaves_like 'not found', :post, :continue

  include_context 'user headers'

  describe 'GET #index by building' do
    it 'returns a success response' do
      building = create :building
      get :index, params: { building_id: building.id }

      expect(response).to be_successful
      expect(response_json).to match_json_schema 'ongoing_tasks'
    end

    it 'returns only ongoing tasks belonging to building' do
      building = create :building
      tasks = create_list :erect_task, 2, taskable: building
      other_building = create :building
      other_tasks = create_list :erect_task, 3, building: other_building

      get :index, params: { building_id: building.id }

      expect(response).to be_successful
      expect(response_json).to match_json_schema 'ongoing_tasks'
      expect(response_json)
        .not_to include(a_hash_including(id: other_tasks[0].id))
      expect(response_json).to contain_exactly(
        a_hash_including(id: tasks[0].id),
        a_hash_including(id: tasks[1].id)
      )
    end
  end

  describe 'GET #index by siege machine' do
    it 'returns a success response' do
      catapult = create :catapult, :with_arm_task
      get :index, params: { siege_machine_id: catapult.id }

      expect(response).to be_successful
      expect(response_json).to match_json_schema 'ongoing_tasks'
    end

    it 'returns only ongoing tasks owned by siege machine' do
      catapult = create :catapult
      tasks = create_list :arm_task, 2, taskable: catapult
      trebuchet = create :trebuchet
      other_tasks = create_list :arm_task, 3, taskable: trebuchet
      get :index, params: { siege_machine_id: catapult.id }

      expect(response).to be_successful
      expect(response_json).to match_json_schema 'ongoing_tasks'
      expect(response_json)
        .not_to include(a_hash_including(id: other_tasks[0].id))
      expect(response_json).to contain_exactly(
        a_hash_including(id: tasks[0].id),
        a_hash_including(id: tasks[1].id)
      )
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      task = create :arm_task
      get :show, params: { id: task.to_param }

      expect(response).to be_successful
      expect(response_json).to match_json_schema 'ongoing_task'
    end
  end

  describe 'POST #continue' do
    include_context 'basic game'

    subject { post :continue, params: params }

    let(:new_char) { create :character }
    let(:params) { { id: task.to_param, character_id: character.to_param } }
    let(:task) { create :arm_task, siege_machine: siege_machine }

    context 'when everything went fine and task is completed' do
      before do
        allow(OngoingTask::Continue)
          .to receive(:call)
          .with(ongoing_task: task, character: character)
          .and_return(trb_result_success_with(ongoing_task: task, ongoing_task_status: 'completed', target: castle))
      end

      it 'is a success' do
        subject
        expect(response).to be_successful
        expect(response).to have_http_status :ok
      end

      it 'refers to OngoingTask::Continue' do
        expect(OngoingTask::Continue)
          .to receive(:call)
          .with(ongoing_task: task, character: character)

        subject
      end

      it 'returns a body with a valid format' do
        subject
        expect(response_json).to match_json_schema 'ongoing_task_result_completed'
      end
    end

    context 'when everything went fine and task is NOT completed' do
      before do
        allow(OngoingTask::Continue)
          .to receive(:call)
          .with(ongoing_task: task, character: character)
          .and_return(trb_result_success_with(ongoing_task: task, ongoing_task_status: 'ongoing'))
      end

      it 'is a success' do
        subject
        expect(response).to be_successful
        expect(response).to have_http_status :ok
      end

      it 'refers to OngoingTask::Continue' do
        expect(OngoingTask::Continue)
          .to receive(:call)
          .with(ongoing_task: task, character: character)

        subject
      end

      it 'returns a body with a valid format' do
        subject
        expect(response_json).to match_json_schema 'ongoing_task_result_still_ongoing'
      end
    end

    it 'returns character not found' do
      post :continue, params: { id: create(:ongoing_task).id, character_id: 'not found' }

      expect(response).to have_http_status :not_found
      expect(response_json).to include error: "Couldn't find Character with 'id'=not found"
    end

    context 'when a bad request is received' do
      it 'cannot continue something when pretending to be someone else' do
        character_from_another_camp = create :character
        post :continue, params: {
          id: create(:ongoing_task).id,
          character_id: character_from_another_camp.id
        }

        expect(response).to have_http_status :unauthorized
        expect(response_json).to include error: 'Not authorized'
      end

      it 'returns bad request when something went wrong' do
        allow(OngoingTask::Continue)
          .to receive(:call)
          .with(ongoing_task: task, character: character)
          .and_return(trb_result_failure_with(error: 'random error'))

        subject
        expect(response).to have_http_status :bad_request
        expect(response_json).to include error: 'random error'
      end
    end
  end
end
