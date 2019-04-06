require 'colorize'

namespace :seed do
  desc 'create THE admin user'
  task create_admin: :environment do
    account_email    = Rails.application.credentials.admin_email
    account_password = Rails.application.credentials.admin_password
    if Account.find_by admin: true
      puts 'Admin user already exists'.red
    else
      account = Account.create(email: account_email, password: account_password, admin: true)
      if account.persisted?
        puts 'Account created'.green
      else
        puts 'Account not created'.red
        puts account.errors.messages.to_s.blue
      end
    end
  end
end
