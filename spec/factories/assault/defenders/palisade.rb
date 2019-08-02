FactoryBot.define do
  factory :palisade, class: Assault::Defender do
    initialize_with { new attributes }

    name { :palisade }
    tags { %i[wall defense_structure] }
    damages { 0 }
    health_points { 150 }
    max_health_points { 150 }

    trait :heavily_damaged do
      health_points { 15 }
    end
  end
end
