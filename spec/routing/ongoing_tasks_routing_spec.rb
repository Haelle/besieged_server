require 'rails_helper'

RSpec.describe OngoingTasksController, type: :routing do
  describe 'routing' do
    it 'routes to #index for buildings' do
      expect(get: '/buildings/1/ongoing_tasks/').to route_to('ongoing_tasks#index', building_id: '1')
    end

    it 'routes to #index for siege_machines' do
      expect(get: '/siege_machines/1/ongoing_tasks/').to route_to('ongoing_tasks#index', siege_machine_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/ongoing_tasks/2').to route_to('ongoing_tasks#show', id: '2')
    end

    describe '#continue aka erect / assemble / arm' do
      shared_examples 'continue action' do |alias_action|
        it "routes to #continue from #{alias_action}" do
          expect(post: "/ongoing_tasks/2/#{alias_action}").to route_to('ongoing_tasks#continue', id: '2')
        end
      end

      it_behaves_like 'continue action', :continue
      it_behaves_like 'continue action', :erect
      it_behaves_like 'continue action', :assemble
      it_behaves_like 'continue action', :arm
    end
  end
end
