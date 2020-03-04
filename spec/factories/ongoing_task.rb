FactoryBot.define do
  factory :ongoing_task do
    association :taskable, factory: :building
    action_points_spent { 0 }
    action_points_required { 10 }
    repeatable { false }

    trait :repeatable do
      repeatable { true }
    end

    trait :not_repeatable do
      repeatable { false }
    end

    trait :almost_completed do
      action_points_spent { 9 }
    end

    trait :completed do
      action_points_spent { 10 }
    end

    trait :for_building do
      association :taskable, factory: :building
    end

    trait :for_siege_machine do
      association :taskable, factory: :siege_machine
    end
  end
end
