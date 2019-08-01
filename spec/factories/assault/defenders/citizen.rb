FactoryBot.define do
  factory :citizen, class: Assault::Defender do
    initialize_with { new attributes }

    name { :citizen }
    tags { [:citizen] }
    damages { 5 }
    damage_range { 1..5 }
    health_points { 10 }
    max_health_points { 10 }

    trait :armed do
      damages { 10 }
      damage_range { 3..5 }
    end
  end
end
