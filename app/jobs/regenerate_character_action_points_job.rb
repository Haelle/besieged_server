class RegenerateCharacterActionPointsJob < ApplicationJob
  queue_as :regenerate_action_points

  def perform
    Character.find_each do |character|
      character.with_lock do
        Character::RegenerateActionPoints
          .call(character: character)
      end
    end
  end
end
