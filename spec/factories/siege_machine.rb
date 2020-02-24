FactoryBot.define do
  factory :siege_machine do
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
  end
end
