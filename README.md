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

# Services (job queues, cache servers, search engines, etc.)

# Deployment instructions

```
mina setup
mina deploy
```

# TODO:
Run mutant !

Add 'arm' action to siege weapon
Add admin:true/false to account with Pundit & authorize :admin
Add concern to check_user_belongs_to_account?
Test forged token !
Create association between Accounts & Characters
Add back office to manager resources !!!
Add seed task to init basic fight
Add Sidekiq-cron to handle PA regen & Raid attacks
