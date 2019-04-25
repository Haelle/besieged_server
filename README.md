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
arm fails if castle destroyed !
