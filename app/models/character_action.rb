class CharacterAction < ApplicationRecord
  belongs_to :camp
  belongs_to :character
  validates :action_type, presence: true
  validates :target_id, presence: true
  validates :target_type, presence: true

  def target
    target_type.constantize.find(target_id)
  end

  def target=(value)
    return if value.nil?

    self.target_type = value.class.name
    self.target_id = value.id
  end
end
