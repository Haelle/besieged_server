require 'colorize'

namespace :seed do
  desc 'setup a basic game environment'
  task setup_game: :environment do
    delete_everything
    Rake::Task['seed:create_admin'].invoke
    admin = Account.find_by admin: true
    account = Account.create email: 'test@example.com', password: 'password'
    operation = Camp::Create.call
    camp = operation[:camp]
    Character.create pseudonym: 'Estb', account: admin, camp: camp
    Character.create pseudonym: 'Axi',  account: account, camp: camp

    puts 'Game created'.green
  end

  private

  def delete_everything
    Character.destroy_all
    Account.destroy_all
    Castle.destroy_all
    SiegeMachine.destroy_all
    Camp.destroy_all
  end
end
