class Castle < ApplicationRecord
  validates :health_points, presence: true
  belongs_to :camp

  def counter_attack
    camp.undergo_assault do |destroyable_object|
      destroyable_object.destroy if target_destroyed?
    end

    reload
  end

  private

  def target_destroyed?
    [true, false].sample
  end
end
