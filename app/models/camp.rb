class Camp < ApplicationRecord
  has_one :castle
  has_many :characters
  has_many :siege_machines

  def undergo_assault
    siege_machines.each do |weapon|
      yield weapon
    end
  end
end
