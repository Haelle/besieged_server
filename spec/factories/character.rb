FactoryBot.define do
  factory :character do
    pseudonym { 'Kevin' }
    account
    camp

    factory :invalid_character do
      pseudonym { nil }
    end
  end
end
