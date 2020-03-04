class OngoingTask < ApplicationRecord
  belongs_to :taskable, polymorphic: true
  attr_reader :error

  validates :action_points_spent, numericality: { greater_than_or_equal_to: 0 }
  validates :action_points_required, numericality: { greater_than: 0 }
  validate :spent_ap_should_be_lower_than_required_ap

  alias_attribute :building, :taskable
  alias_attribute :siege_machine, :taskable

  def completed?
    action_points_spent == action_points_required
  end

  private

  def spent_ap_should_be_lower_than_required_ap
    return if action_points_spent <= action_points_required

    errors.add(:logic, 'cannot spend more action points than required')
  rescue StandardError
    errors.add(:rescue, "rescued error #{$ERROR_INFO}")
  end
end
