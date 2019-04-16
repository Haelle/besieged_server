class Camp < ApplicationRecord
  has_one :castle
  has_many :characters
  has_many :siege_weapons

  def undergo_assault
    siege_weapons.each do |weapon|
      yield weapon
    end
  end
end
