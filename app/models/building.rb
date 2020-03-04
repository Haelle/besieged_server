class Building < ApplicationRecord
  has_paper_trail
  belongs_to :camp
  has_many :ongoing_tasks, dependent: :destroy, as: :taskable

  validates :building_type, inclusion: { in: %w[tactical_operation_center siege_machine_workshop] }
end
