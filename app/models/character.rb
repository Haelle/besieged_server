class Character < ApplicationRecord
  has_paper_trail
  validates :pseudonym, presence: true
  validate :only_one_character_per_camp,
    :action_points_must_be_within_allowed_range

  belongs_to :account
  belongs_to :camp

  def max_action_points
    24
  end

  def action_point_regeneration_rate
    6
  end

  def exhausted?
    action_points.zero?
  end

  private

  def action_points_must_be_within_allowed_range
    return if action_points.between?(0, max_action_points)

    errors.add(:action_points, "action_points cannot be lower than 0 and greater thant #{max_action_points}")
  end

  def only_one_character_per_camp
    return if camp.nil? || no_character_already_in_camp?

    errors.add(:camp, 'an account can only have one character per camp')
  end

  def no_character_already_in_camp?
    camp
      .characters
      .where(account: account)
      .reject { |c| c == self }
      .empty?
  end
end
