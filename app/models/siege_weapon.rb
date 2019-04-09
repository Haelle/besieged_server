class SiegeWeapon < ApplicationRecord
  belongs_to :camp
  validates :damage, presence: true
end
