FactoryBot.define do
  factory :siege_weapon do
    damages { 1 }
    name { 'random name' }
    camp

    factory :invalid_siege_weapon do
      damages { nil }
      name { nil }
    end
  end
end
