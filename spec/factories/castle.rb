FactoryBot.define do
  factory :castle do
    health_points { 500 }

    factory :invalid_castle do
      health_points { nil }
    end

    trait :with_armed_camp do
      after :build do |castle|
        create :camp,
          :with_siege_machines,
          :with_buildings,
          :with_characters,
          castle: castle
      end
    end
  end
end
