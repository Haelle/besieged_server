class Castle < ApplicationRecord
  validates :health_points, presence: true
  belongs_to :camp
end
