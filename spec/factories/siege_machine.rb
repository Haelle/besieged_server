FactoryBot.define do
  factory :siege_machine do
    siege_machine_type { 'catapult' }
    damages { 1 }
    name { 'random name' }
    camp

    factory :invalid_siege_machine do
      damages { nil }
      name { nil }
    end

    factory :catapult do
      siege_machine_type { 'catapult' }
    end

    factory :ballista do
      siege_machine_type { 'ballista' }
    end

    factory :trebuchet do
      siege_machine_type { 'trebuchet' }
    end

    trait :with_ongoing_tasks do
      after :create do |machine|
        create_list :arm_task, 3, taskable: machine
      end
    end
  end
end
