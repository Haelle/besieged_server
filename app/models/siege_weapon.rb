class SiegeWeapon < ApplicationRecord
  belongs_to :camp
  validates :damages, presence: true
end
