class SiegeMachine < ApplicationRecord
  belongs_to :camp
  validates :damages, presence: true
  validates :name, presence: true
end
