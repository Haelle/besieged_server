FactoryBot.define do
  factory :character do
    pseudonyme { 'Kevin' }
    account

    factory :invalid_character do
      pseudonyme { nil }
    end
  end
end
