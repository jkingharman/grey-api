# Grey API

__WIP__. A [Grape-based](http://www.ruby-grape.org) API returning data on London skate spots. It will serve an Expo-based React Native app eventually.

You can explore the API via the [Swagger demo](https://petstore.swagger.io/#/). Point the demo to: https://grey-api.herokuapp.com/swagger_doc

## What's it do? ##

The API is an MVP and so operates on a minimal set of data. You can crud skate spots and read from skate spot types. It also has basic search. 

Write operations need authentication, meaning you can't do them via the Swagger demo.

## Testing ##

Grey has a test suite. You need Ruby (see `.ruby-version`) and a local Postgres. Then:

```
cd grey-api
bin/setup
bin/test
```

`bin/setup` installs gems, writes a gitignored `.env`, and creates and migrates a dev
database. `bin/test` provisions its own test database and runs rspec; args pass through
(`bin/test -fd`). `bin/server` boots the API and `bin/console` opens irb.

## Core Dependencies ##

* Grape
* ActiveRecord
* PostgreSQL
* PgSearch
* Rake
* RSpec
