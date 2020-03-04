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

    factory :arm_task, class: OngoingTasks::SiegeMachine::ArmTask do
      for_siege_machine
    end

    factory :erect_task, class: OngoingTasks::Building::ErectTask do
      params { { building_type: 'siege_machine_workshop' } }
      for_building
    end

    factory :assemble_task, class: OngoingTasks::Building::AssembleTask do
      params { { siege_machine_type: 'catapult' } }
      for_building
    end
  end
end
