# README

Ruby version: 2.6.2

# Configuration
Need to have pgcrypto extention to be installed
```
sudo apt-get install postgresql-contrib
```

# Database creation

Create role with an account with sufficient rights:
```
psql -f setup_postgres.sql
```

Create database:
```
rake db:setup
rails db:migrate
```

## Database initialization

# How to run the test suite

```
rspec
```

## Mutant

```
RAILS_ENV=test bundle exec mutant -r ./config/environment --use rspec ClassName
```

# Services (job queues, cache servers, search engines, etc.)

# Deployment instructions

```
mina setup
mina deploy
```

# TODO:
Move requests specs in resources folder
Add 'arm' action to siege weapon

Add admin:true/false to account with Pundit & authorize :admin
  only YOU or admin can upate an account
  a lot of actions should only be performed by admin !!!
  ALL resources actions should only be done by admin
    => trailblazer operation should handle all creations with contracts & cie

Add concern to check_user_belongs_to_account?
Add back office to manager resources !!!
Add seed task to init basic fight
Add Sidekiq-cron to handle PA regen & Raid attacks
