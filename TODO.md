# TODO

**Rule: no feature work until the operational improvements below are done.**
The codebase's architecture is sound; what needs fixing is the operational shell
around it — verification, tooling, and broken wiring. These also prepare the repo
for agentic engineering, where fast trustworthy feedback loops are the ground truth.

## 1. Testing: hermetic and self-provisioning (first)

- [ ] Dedicated test database — stop sharing test/dev. Do this before anything else:
      truncation against the shared DB means running the suite destroys dev data.
- [ ] `bin/test` (or rake default): sane env defaults, create/migrate the test DB if
      absent, run rspec. Green from a cold clone with zero manual steps.
- [ ] Set `ENV['RACK_ENV'] = 'test'` (and defaults for `API_KEY`/`DATABASE_URL`) at the
      top of `spec_helper.rb`, before requires — `Config.rack_env` memoizes.
- [ ] Kill order-dependence: interpolate created record IDs in API specs instead of
      hardcoding (`get "/v0/spots/#{@spot_one.id}"`). Suite currently relies on
      truncation-at-boot sequence resets plus lucky file ordering.
- [ ] Cover the untested middleware zone: unit-test `ApiLogLine` (fake emitter, assert
      emitted fields) and `Instrumentation` (assert env). All known live bugs are here.

## 2. CI and lint

- [ ] GitHub Actions: Postgres service container, run the suite on push/PR.
- [ ] Add Standard (or RuboCop) and wire it into CI.

## 3. Sharpen CLAUDE.md

- [ ] Add a verification contract: exact commands to run all tests, one test, boot the
      server, migrate.
- [ ] Keep known-broken warnings current; delete each warning when the landmine is fixed.

## 4. Fix the broken observability wiring

- [ ] `api_log_line.rb` references undefined `Grey::ApiError` (should be
      `Grey::Api::Error`) — errored requests lose their log line entirely.
- [ ] Error UUID is generated but never returned to the client — breaks correlation.
- [ ] `Instrumentation` sets `env['REQUEST_ID']` after `@app.call` — app never sees it;
      echo it in a response header.
- [ ] Error responses use `content-type: text/error` — should be `application/json`.

## 5. Consolidate boot

- [ ] Extract one `lib/grey/boot.rb` (Bundler, load path, requires, DB connection);
      make `config.ru`, `Rakefile`, `bin/console`, `spec_helper.rb` one-liners.
- [ ] Replace the `Rack::CommonLogger` monkey patch (`lib/grey/monkey_patch.rb`) with
      `rackup -q` or env-based config, and document.
- [ ] Consider Zeitwerk to replace the manual require list in `lib/grey.rb`.

## 6. Migration tooling

- [ ] `db:migrate` should default to latest instead of requiring `VERSION`.
- [ ] Fix `db:rollback` (known-broken, `@todo` in Rakefile).
- [ ] Add a schema dump to `db/`.

## Later / unblocked from features

- [ ] Deployment story: README points at Heroku free tier (gone since Nov 2022) and
      `procfile` is lowercase (Heroku requires `Procfile`). Pick a target.
- [ ] Serializers: termination of SpotType/Spot recursion is by convention only —
      make it structural (or adopt Blueprinter) before adding a third nested model.
- [ ] Auth/CORS posture (`origins '*'`, single shared Basic key) — fine for MVP;
      revisit only if extension means users or per-client writes.
