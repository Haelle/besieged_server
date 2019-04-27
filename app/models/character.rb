class Character < ApplicationRecord
  validates :pseudonyme, presence: true
  validate :only_one_character_per_camp

  belongs_to :account
  belongs_to :camp

  private

  def only_one_character_per_camp
    if !camp.nil? && already_a_character_in_camp?
      errors.add(:camp, 'an account can only have one character per camp')
    end
  end

  def already_a_character_in_camp?
    camp.characters.where(account: account).any?
  end
end
