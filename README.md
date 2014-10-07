# Getting Started
Install things

    bundle install

Setup your database

    bundle exec rake db:setup

    # want the example users?
    bundle exec rake dev:setup
    ... now you have user@foo.com and admin@foo.com (password = password)

Run sidekiq

    bundle exec sidekiq -c 1

Run redis

    redis-server

Run the server

    bin/rails server

Navigate to `localhost:3000`

# Live configuration

    RISK_SCORE_MILES_UNTIL_GIVING_UP = 3

    RISK_SCORE_PCT_FATHER_WILLING_TO_GO_PAST_BAD = 30.0