FactoryBot.define do
  factory :account do
    email { 'email@example.com' }
    password { 'password' }

    factory :invalid_account do
      email { 'invalid email' }
    end
  end
end
