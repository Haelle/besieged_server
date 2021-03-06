require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
require 'colorize'

ENV['to'] ||= 'sandbox'
%w[sandbox production].include?(ENV['to']) || raise("#{ENV['to']} env not available")

comment "Deploying on #{ENV['to'].upcase.green}"

set :commit, ENV['tag'] || ENV['commit']
ensure!(:branch) if ENV['to'] == 'production'

set :application_name, 'besieged'
set :domain, 'besieged.alxs.fr'
set :deploy_to, "/var/www/besieged_#{ENV['to']}"
set :rails_env, ENV['to']
set :repository, 'git@github.com:Haelle/besieged_server.git'
set :rbenv_path, '/usr/local/rbenv'
set :bundle_bin, '/usr/local/rbenv/shims/bundle'
set :user, 'deploy'

# Optional settings:
#   set :port, '30000'           # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# Shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# Some plugins already add folders to shared_dirs like `mina/rails` add `public/assets`, `vendor/bundle` and many more
# run `mina -d` to see all folders and files already included in `shared_dirs` and `shared_files`
# set :shared_dirs, fetch(:shared_dirs, []).push('public/assets')
# set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml')
set :shared_files, fetch(:shared_files, []).push(
  'config/database.yml',
  'config/master.key',
  'config/sidekiq.yml'
)

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :remote_environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  invoke :'rbenv:load'
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  command %(rbenv install 2.6.2 --skip-existing)
end

desc 'Deploys the current version to the server.'
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    set :bundle_options, fetch(:bundle_options) + ' --clean'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command %(mkdir -p tmp/)
        command %(touch tmp/restart.txt)
        invoke :sidekiq
        invoke :create_admin
      end
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs

task :sidekiq do
  comment 'Restarting Sidekiq (reloads code)'.green
  command %(sudo systemctl restart sidekiq_besieged_#{ENV['to']})
end

task :create_admin do
  comment 'Creating admin user'.green
  command %(#{fetch(:rake)} seed:create_admin)
end
