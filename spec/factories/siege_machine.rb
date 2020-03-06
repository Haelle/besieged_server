FactoryBot.define do
  factory :siege_machine do
    damages { 1 }
    sequence(:position)
    name { 'random name' }
    camp

    trait :with_arm_task do
      after :create do |machine|
        create :arm_task, taskable: machine
      end
    end

    factory :catapult, class: SiegeMachines::Catapult do
      factory :invalid_catapult do
        damages { nil }
        name { nil }
      end
    end

    factory :ballista, class: SiegeMachines::Ballista
    factory :trebuchet, class: SiegeMachines::Trebuchet
  end
end
