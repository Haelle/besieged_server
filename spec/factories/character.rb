FactoryBot.define do
  factory :character do
    pseudonyme { 'Kevin' }
    account
    camp

    factory :invalid_character do
      pseudonyme { nil }
    end
  end
end
