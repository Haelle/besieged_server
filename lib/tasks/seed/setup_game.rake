require 'colorize'

namespace :seed do
  desc 'setup a basic game environment'
  task setup_game: :environment do
    delete_everything
    Rake::Task['seed:create_admin'].invoke
    admin = Account.find_by admin: true
    account = Account.create email: 'test@example.com', password: 'password'
    camp = Camp.create
    Castle.create health_points: 500, camp: camp
    Character.create pseudonyme: 'Estb', account: admin, camp: camp
    Character.create pseudonyme: 'Axi',  account: account, camp: camp
    10.times do |i|
      SiegeMachine.create damages: (i + 1) * 10, camp: camp
    end

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
