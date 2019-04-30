FactoryBot.define do
  factory :siege_weapon do
    damages { 1 }
    camp

    factory :invalid_siege_weapon do
      damages { nil }
    end
  end
end
