FactoryBot.define do
  factory :siege_machine do
    damages { 1 }
    name { 'random name' }
    camp

    factory :invalid_siege_machine do
      damages { nil }
      name { nil }
    end
  end

  factory :catapult, parent: :siege_machine, class: SiegeMachines::Catapult
  factory :ballista, parent: :siege_machine, class: SiegeMachines::Ballista
  factory :trebuchet, parent: :siege_machine, class: SiegeMachines::Trebuchet
end