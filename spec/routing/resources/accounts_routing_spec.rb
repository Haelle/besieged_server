require 'rails_helper'

RSpec.describe Resources::AccountsController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/accounts/1').to route_to('resources/accounts#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/accounts').to route_to('resources/accounts#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/accounts/1').to route_to('resources/accounts#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/accounts/1').to route_to('resources/accounts#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/accounts/1').to route_to('resources/accounts#destroy', id: '1')
    end
  end
end
