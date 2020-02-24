FactoryBot.define do
  factory :castle do
    health_points { 500 }
    camp

    factory :invalid_castle do
      health_points { nil }
    end

    trait :with_armed_camp do
      before :create do |castle|
        create :camp, :with_weapons, castle: castle
      end
    end
  end
end
