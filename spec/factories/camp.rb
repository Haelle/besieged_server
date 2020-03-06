FactoryBot.define do
  factory :camp do
    after :create do |camp|
      create :castle, camp: camp
    end

    trait :with_characters do
      after :create do |camp|
        create_list :character, 3, camp: camp
      end
    end

    trait :with_siege_machines do
      after :create do |camp|
        create_list :catapult, 3, :with_arm_task, camp: camp
        create_list :ballista, 5, :with_arm_task, camp: camp
        create_list :trebuchet, 2, :with_arm_task, camp: camp
      end
    end

    trait :with_buildings do
      after :create do |camp|
        create :toc, camp: camp
        create :siege_machine_workshop, :with_ongoing_tasks, camp: camp
      end
    end

    factory :settled_camp do
      with_characters
      with_siege_machines
      with_buildings
    end
  end
end
