FactoryBot.define do
  factory :account do
    sequence(:email) { |n| "email_#{n}@example.com" }
    password { 'password' }

    factory :invalid_account do
      email { 'invalid email' }
    end
  end
end
