class SiegeMachine < ApplicationRecord
  has_paper_trail
  belongs_to :camp
  has_many :ongoing_tasks, dependent: :destroy, as: :taskable

  validates :damages, presence: true
  validates :name, presence: true
  validates :siege_machine_type, inclusion: { in: %w[ballista catapult trebuchet] }
end
