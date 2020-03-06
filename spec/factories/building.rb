FactoryBot.define do
  factory :building do
    camp

    trait :with_ongoing_tasks do
      after :create do |building|
        create_list :assemble_task, 3, taskable: building
      end
    end

    factory :siege_machine_workshop, aliases: [:workshop], class: Buildings::SiegeMachineWorkshop
    factory :tactical_operation_center, aliases: [:toc], class: Buildings::TacticalOperationCenter
  end
end
