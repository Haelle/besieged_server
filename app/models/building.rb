class Building < ApplicationRecord
  belongs_to :camp
  has_many :ongoing_tasks, dependent: :destroy, as: :taskable
end
