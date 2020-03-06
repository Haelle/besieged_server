class SiegeMachine < ApplicationRecord
  belongs_to :camp
  has_many :ongoing_tasks, dependent: :destroy, as: :taskable

  validates :damages, presence: true
  validates :name, presence: true
end
