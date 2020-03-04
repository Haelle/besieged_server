class Camp < ApplicationRecord
  has_one :castle, dependent: :destroy
  has_many :characters, dependent: :destroy
  has_many :siege_machines, dependent: :destroy
  has_many :buildings, dependent: :destroy

  def undergo_assault
    siege_machines.each do |weapon|
      yield weapon
    end
  end
end
