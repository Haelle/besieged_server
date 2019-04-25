FactoryBot.define do
  factory :camp do
    trait :with_weapons do
      after :create do |camp|
        create_list :siege_weapon, 3, camp: camp
      end
    end

    trait :with_castle do
      after :create do |camp|
        create :castle, camp: camp
      end
    end

    trait :with_characters do
      after :create do |camp|
        create_list :character, 3, camp: camp
      end
    end
  end
end
