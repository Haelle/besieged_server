FactoryBot.define do
  factory :character_action do
    camp
    character
    action_type { 'fake action' }
    target_id { 'dummy id' }
    target_type { 'NotAClass' }

    factory :invalid_character_action do
      action_type { nil }
      target_id { nil }
      target_type { nil }
    end
  end
end
