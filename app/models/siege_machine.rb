class SiegeMachine < ApplicationRecord
  belongs_to :camp
  has_many :ongoing_tasks, dependent: :destroy, as: :taskable

  validates :damages, presence: true
  validates :name, presence: true
  validate :only_one_resource_per_index_position

  def self.next_position_vacancy(camp)
    positions = where(camp: camp).pluck(:position)
    return 0 if positions.empty?

    max = positions.max + 1
    gaps = (0..max).to_a - positions
    gaps.min
  end

  private

  def only_one_resource_per_index_position
    return if camp.nil? || camp.id.nil?

    return unless any_other_in_position?

    errors.add(:position, "Another #{self.class.name} is already in position #{position}")
  end

  def any_other_in_position?
    self
      .class
      .where(camp: camp, position: position)
      .reject { |m| m == self }
      .any?
  end
end
