# Grey API

__WIP__. A [Grape-based](http://www.ruby-grape.org) API returning data on London skate spots. It will serve an Expo-based React Native app eventually.

You can explore the API via the [Swagger demo](https://petstore.swagger.io/#/). Point the demo to: https://grey-api.herokuapp.com/swagger_doc

## What's it do? ##

The API is an MVP and so operates on a minimal set of data. You can perform CRUD on skate spots and read from skate spot types. It also has basic search. 

Write operations need authentication, meaning they're not performable via the Swagger demo.

## Testing ##

Grey has a test suite. To run it, first checkout this repo:

```
cd grey-api
bundle install
```

You'll then need some setup. Create a Postgres database for the API by running (e.g): ```createdb grey-api-test``` from your shell. Next configure your environment:

```
export DATABASE_URL="[your test DB URL here]"
export API_KEY="[your dummy API key here]"
```

Finally, migrate:

```
rake environment
rake db:migrate VERSION=1554479266
```

Now you should be good to test: ```rspec -fd```

## Core Dependencies ##

* Grape
* ActiveRecord
* PostgreSQL
* PgSearch
* Rake
* RSpec
