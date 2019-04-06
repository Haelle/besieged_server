FactoryBot.define do
  factory :character do
    pseudonyme { 'Kevin' }

    factory :invalid_character do
      pseudonyme { nil }
    end
  end
end
