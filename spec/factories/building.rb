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
  end
end
