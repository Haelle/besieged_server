class CharacterAction < ApplicationRecord
  belongs_to :camp
  belongs_to :character
  validates :action_type, presence: true
  validates :target_id, presence: true
  validates :target_type, presence: true
end
