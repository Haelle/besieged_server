require 'rails_helper'

RSpec.describe SiegeMachines::Catapult, type: :model do
  it_behaves_like 'only one siege machine per position'
  it_behaves_like 'positionable resource'
end
