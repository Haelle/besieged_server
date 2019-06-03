require 'rails_helper'

RSpec.describe NamesController, type: :routing do
  describe 'routing' do
    it 'routes to #generate with default param' do
      expect(get: '/names/generate').to route_to('names#generate', syllables_count: '4')
    end

    it 'routes to #generate with expected param' do
      expect(get: '/names/generate/2').to route_to('names#generate', syllables_count: '2')
    end
  end
end
