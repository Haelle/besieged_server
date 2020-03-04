FactoryBot.define do
  factory :building do
    camp
    building_type { 'siege_machine_workshop' }

    factory :siege_machine_workshop do
      building_type { 'siege_machine_workshop' }
    end

    factory :tactical_operation_center, aliases: [:toc] do
      building_type { 'tactical_operation_center' }
    end

    trait :with_ongoing_tasks do
      after :create do |building|
        create_list :erect_task, 3, taskable: building
      end
    end
  end
end
