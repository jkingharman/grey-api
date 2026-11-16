# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> This doc captures durable conventions — *how* things are done here. For volatile
> specifics (versions, the resource/file list, migration timestamps) it points at the
> source of truth in the repo rather than copying a snapshot that will rot. When you
> need a current fact, read the source, don't trust a number transcribed here.

## Why this project exists

Grey is instrumental: it exists so John can practise agentic engineering, not for its
own sake. Operating rules:

- Before starting a task, propose a technique x feature pairing from
  `docs/agentic-backlog.md`, favouring techniques not practised recently. The backlog
  is seed material, not a contract: if John rejects a pairing, propose another feature
  or technique on the spot.
- No feature ships without deliberately exercising a technique.
- Features skew infrastructure / operational / architectural over CRUD.

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

- Scripts under `bin/` follow GitHub's scripts-to-rule-them-all layering: `bootstrap`
  (deps only) -> `setup` (deps + `.env` + dev DB + migrate) -> `server` / `console` /
  `test` / `lint`, each calling the layer beneath. All are idempotent and cold-start safe.
- First run on a fresh clone: `bin/setup`. Writes a gitignored `.env`, creates
  `grey_dev_<repo dir basename>`, migrates. Re-running only migrates.
- Run locally: `bin/server` (port 9292; args pass to rackup). Procfile uses `-p $PORT`.
- Console: `bin/console` (irb with the app booted).
- All tests: `bin/test` — creates the test DB if absent, migrates it, runs rspec. Green
  from a cold clone with no env vars set and no `.env`. Args pass through: `bin/test -fd`.
- Lint: `bin/lint` (Standard, no config file); `bin/lint --fix` autocorrects. A Claude Code
  hook (`.claude/settings.json` -> `bin/lint-hook`) autocorrects any Ruby file Claude edits.
- Single test: `bin/test path/to/spec.rb:LINE` or `bin/test -e "description"`. Plain
  `bundle exec rspec` also works with no env vars once the DB exists.
- Migrate: `bin/setup` migrates the dev DB. Bare `rake db:create` / `rake db:migrate` need
  `DATABASE_URL` in the shell (`set -a; . ./.env; set +a`). `VERSION=<timestamp>` targets
  one. `rake db:rollback` is known-broken (`@todo: fix` in Rakefile).

## Required env vars

Rule: **no secret and no connection string gets a default in code.** `Grey::Config`
raises when a var is missing (`lib/grey/config.rb`) and that must stay. Dev values live in
a per-checkout `.env` that `bin/setup` generates and git ignores; only `bin/` scripts read
it (shell `source`, no dotenv gem). Prod gets real env vars.

- `DATABASE_URL` — Postgres connection string. **Mandatory** — raised at boot by
  `lib/grey/boot.rb`, the single boot path used by `config.ru`, `Rakefile`, `bin/console`
  and `spec_helper.rb`.
- `API_KEY` — HTTP Basic auth secret for write ops (POST/PUT/DELETE). Reads are public.
  Raised lazily, when an auth check / write actually runs. `bin/setup` generates a random
  dev key into `.env`.
- `RACK_ENV` — optional, defaults to `production`. `.env` sets `development`.

**Tests need none of these.** `spec_helper.rb` sets all three before any require and
**overrides** ambient `DATABASE_URL` with a derived name, `grey_test_<repo dir basename>`
(`spec/support/test_database.rb`), so separate worktrees get separate DBs. Override the
derivation with `TEST_DATABASE_URL` (e.g. CI with host/credentials); the DB name must still
start with `grey_test_` or the suite aborts before touching it.

## Layout (under lib/grey/)

- `api/` — Grape endpoints (`spot_api.rb`, `spot_type_api.rb`), mounted in
  `api_aggregator.rb`. `helpers.rb` holds `authorize!` / `required_params!`;
  `errors.rb` holds custom error classes.
- `models/` — ActiveRecord models (`spot.rb` uses pg_search full-text scope).
- `serializers/` — JSON serialization, kept separate from models; `base_serializer.rb`
  dispatches on a type symbol.
- `middleware/` — Rack middleware (`api_log_line`, `instrumentation`), wired in `config.ru`.
- `config.rb` — env-var access via `Grey::Config`.
- `boot.rb` — bundler, load path, `require "grey"`, `establish_connection`. Every entry
  point requires this instead of repeating the preamble.

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
- API specs use `Rack::Test::Methods`, `let(:app) { ... }`, build records in `before(:each)`.
- Examples run in random order; reproduce an order failure with `bin/test --seed N`.
- No factories/fixtures — records built inline.
- Shared helpers in `spec/support/helpers.rb`: `response_body`, `stringify_keys`,
  `serialize_generic`.

## Gotchas

- CI runs `bin/test` and `bin/lint` on PRs and pushes to master
  (`.github/workflows/test.yml`, Postgres 16 service container).
- Swagger doc served at `/swagger_doc` (grape-swagger).
