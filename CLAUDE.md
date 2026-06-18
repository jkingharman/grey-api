# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> This doc captures durable conventions — *how* things are done here. For volatile
> specifics (versions, the resource/file list, migration timestamps) it points at the
> source of truth in the repo rather than copying a snapshot that will rot. When you
> need a current fact, read the source, don't trust a number transcribed here.

## What this is

A **Grape API on plain Rack** — NOT Rails. ActiveRecord is used standalone for
persistence; there is no `app/`, no Rails CLI, no `config/environments`.
Serves London skate-spot data. All code lives under `lib/grey/`. Resources are the
classes mounted in `lib/grey/api_aggregator.rb` (one Grape class per resource under
`lib/grey/api/`).

## Stack

- **Not Rails**: Grape on plain Rack, ActiveRecord standalone, Postgres via `pg` +
  `pg_search` (full-text), RSpec for tests, puma in production.
- Ruby version → `.ruby-version` (also pinned in `Gemfile`). Gem versions → `Gemfile.lock`.
  Read those for exact numbers.

## Run / test / migrate

- Run locally: `bundle exec rackup config.ru` (port 9292). Procfile uses `-p $PORT`.
- All tests: `rspec -fd`
- Single test: `rspec path/to/spec.rb:LINE` or `rspec -e "description"`
- Migrate: `rake environment && rake db:migrate VERSION=<timestamp>` — the custom rake task
  REQUIRES `VERSION` (the latest migration's timestamp, i.e. the newest file in
  `db/migrate/`); without it nothing migrates. `rake db:rollback` is known-broken
  (`@todo: fix` in Rakefile).

## Required env vars (no defaults, no .env file)

- `DATABASE_URL` — Postgres connection string. **Mandatory** — `Grey::Config` raises at
  boot if unset (`lib/grey/config.rb`). Read at boot in `config.ru`, `spec_helper.rb`, `Rakefile`.
- `API_KEY` — HTTP Basic auth secret for write ops (POST/PUT/DELETE). Reads are public.
  Raised lazily, when an auth check / write actually runs.
- `RACK_ENV` — optional, defaults to `production`. Specs force it to `test`.

To run the suite locally these must be set, e.g.:
`DATABASE_URL="postgres:///grey-api-test" API_KEY="dummy" RACK_ENV="test" bundle exec rspec -fd`

## Layout (under lib/grey/)

- `api/` — Grape endpoints (`spot_api.rb`, `spot_type_api.rb`), mounted in
  `api_aggregator.rb`. `helpers.rb` holds `authorize!` / `required_params!`;
  `errors.rb` holds custom error classes.
- `models/` — ActiveRecord models (`spot.rb` uses pg_search full-text scope).
- `serializers/` — JSON serialization, kept separate from models; `base_serializer.rb`
  dispatches on a type symbol.
- `middleware/` — Rack middleware (`api_log_line`, `instrumentation`), wired in `config.ru`.
- `config.rb` — env-var access via `Grey::Config`.

## Conventions

- Every file starts with `# frozen_string_literal: true` — match it.
- **Grape endpoint shape**: `version 'v0', using: :path`; `format :json`; a `helpers`
  block that `include Api::Helpers` and defines `serializer` / `serialize`; routes
  inside `resource :name do ... end`.
- **Auth**: reads public; writes (POST/PUT/DELETE) call `authorize!` (HTTP Basic,
  credentials `['user', Config.api_key]`). Missing params via `required_params!(:key)`.
- **Errors**: `Grey::Api::Error` hierarchy — `NotFound` (404), `MissingParam` (422),
  `Unauthorized` (401). Rescued centrally in `api_aggregator.rb`, returned as JSON with
  `content-type: text/error`. Lookup idiom: `Model.find_by(id: ...) || raise(Error::NotFound)`.
- **Serializers**: `BaseSerializer#initialize(type)`, then `#serialize` dispatches via
  `send(@type, obj)`; arrays handled by `map`. A serializer can expose multiple output
  shapes (e.g. `api`, `nested_spots`).
- **Models**: pg_search `search_by_name` over a `tsv` column; `random` / `latest` scopes;
  slug downcased in `before_validation`; presence + uniqueness + slug-format validations.

## Test conventions

- Specs mirror `lib/` under `spec/lib/grey/...`.
- API specs use `Rack::Test::Methods`, `let(:app) { ... }`, build records in `before(:all)`.
- No factories/fixtures — records built inline.
- Shared helpers in `spec/support/helpers.rb`: `response_body`, `stringify_keys`,
  `serialize_generic`.

## Gotchas

- Test and dev share one database (see TODO in `spec/spec_helper.rb`); DatabaseCleaner uses
  `:truncation`. Don't point `DATABASE_URL` at data you care about when testing.
- **No linter** (no RuboCop/Standard config) and **no CI** (no `.github/workflows`).
- Swagger doc served at `/swagger_doc` (grape-swagger).
