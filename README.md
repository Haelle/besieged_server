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

Check mutation code resistance:

```
RAILS_ENV=test bundle exec mutant -r ./config/environment --use rspec ClassName
```

## Flog
Check code complexity
```
flog -g app
```

# Services (job queues, cache servers, search engines, etc.)

# Deployment instructions

```
mina setup
mina deploy
```
