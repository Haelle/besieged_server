class Castle < ApplicationRecord
  validates :health_points, numericality: { greater_than_or_equal_to: 0 }
  belongs_to :camp

  def counter_attack
    camp.undergo_assault do |destroyable_object|
      destroyable_object.destroy if target_destroyed?
    end

    reload
  end

  private

  def target_destroyed?
    rand(10) <= 1
  end
end
