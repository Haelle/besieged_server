FactoryBot.define do
  factory :account do
    sequence(:email) { |n| "email_#{n}@example.com" }
    password { 'password' }

    factory :invalid_account do
      email { 'invalid email' }
    end

    trait :with_character do
      after :create do |account|
        create :character, account: account
      end
    end
  end
end
