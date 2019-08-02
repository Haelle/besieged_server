FactoryBot.define do
  factory :infantry_squad, class: Assault::Assaulter do
    initialize_with { new attributes }

    name { :infantry_squad }
    tags { [:infantry] }
    damages { 20 }
    damage_range { 1..4 }
    health_points { 50 }
    max_health_points { 50 }
  end
end
