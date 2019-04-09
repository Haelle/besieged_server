FactoryBot.define do
  factory :castle do
    health_points { 500 }
    camp

    factory :invalid_castle do
      health_points { nil }
    end
  end
end
