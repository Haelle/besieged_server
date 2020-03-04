class Camp < ApplicationRecord
  has_paper_trail
  has_one :castle, dependent: :destroy
  has_many :characters, dependent: :destroy
  has_many :siege_machines, dependent: :destroy
  has_many :buildings, dependent: :destroy

  def tactical_operation_center
    buildings.find do |building|
      building.building_type == 'tactical_operation_center'
    end
  end
  alias toc tactical_operation_center

  def undergo_assault
    siege_machines.each do |weapon|
      yield weapon
    end
  end
end
