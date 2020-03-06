FactoryBot.define do
  factory :character do
    pseudonym { 'Kevin' }
    action_points { 6 }
    account
    camp

    factory :invalid_character do
      pseudonym { nil }
    end

    trait :exhausted do
      action_points { 0 }
    end
  end
end
