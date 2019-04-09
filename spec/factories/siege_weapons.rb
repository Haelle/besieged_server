FactoryBot.define do
  factory :siege_weapon do
    damage { 1 }
    camp

    factory :invalid_siege_weapon do
      damage { nil }
    end
  end
end
