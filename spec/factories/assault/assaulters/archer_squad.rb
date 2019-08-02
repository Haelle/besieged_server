FactoryBot.define do
  factory :archer_squad, class: Assault::Assaulter do
    initialize_with { new attributes }

    name { :archer_squad }
    tags { [:archer] }
    damages { 25 }
    damage_range { 1..1 }
    health_points { 30 }
    max_health_points { 30 }
  end
end
