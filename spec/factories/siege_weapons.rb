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
end
