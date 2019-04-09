class Camp < ApplicationRecord
  has_one :castle
  has_many :characters
  has_many :siege_weapons
end
