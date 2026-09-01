# Agentic engineering backlog

Grey is a vehicle for practising agentic engineering (see CLAUDE.md "Why this project
exists"). Two lists below: techniques to practise and features to practise them on.
Pairings are proposed at task time, not fixed here — these are seeds, and a rejected
pairing just means proposing another. Nothing is tracked or ticked off: repeated
exposure comes from re-pairing the same technique with new features over time.

Features skew infrastructure, operations, and architecture — things Rails normally
does for you, hand-rolled small here so the mechanism is visible.

## Techniques (roughly cost-ordered)

0. `/fewer-permission-prompts` → project `.claude/settings.json` allowlist. Prerequisite
   for every hands-off technique below.
1. Prompting styles on the same class of task: TDD-first vs fully hands-off vs
   `/code-review --fix`. Compare the experience.
2. Plan mode with a written spec.
3. A custom skill encoding a recurring pattern — e.g. a safe-migration scaffold, or a
   new Grape resource (endpoint + serializer + spec + mount). Forces the conventions
   to be articulated precisely enough for an agent to follow.
4. Hooks beyond lint: PostToolUse running the touched specs, PreToolUse guarding
   migrations. Hooks run outside the model's context — enforcement, not prompting.
5. A read-only reviewer subagent with its own instructions, separate from the author.
6. A Postgres MCP server against the dev DB.
7. Headless `claude -p` as a build step (a report, a changelog, a validation pass).
8. Parallel worktrees, two agents on independent slices. Per-worktree test DBs already
   support this.
9. Multi-agent workflow / agent team on a multi-step feature.
10. Driving work from `gh` issues with acceptance criteria.

## Features (seeds, not a contract)

### Groundwork

- Fix the observability wiring: `api_log_line.rb` references undefined
  `Grey::ApiError` (should be `Grey::Api::Error`) so errored requests lose their log
  line; the error UUID is never returned to the client; `Instrumentation` sets
  `env['REQUEST_ID']` after `@app.call` so the app never sees it (echo it in a
  response header); error responses use `content-type: text/error` instead of
  `application/json`. Cover `ApiLogLine` and `Instrumentation` with unit specs while
  there — the middleware zone is untested and all known bugs live in it.
- Migration tooling: fix `db:rollback` (known-broken, `@todo` in Rakefile); add a
  schema dump to `db/`.
- Consolidate boot: one `lib/grey/boot.rb` so `config.ru`, `Rakefile` and
  `spec_helper.rb` become one-liners; replace the `Rack::CommonLogger` monkey patch
  (`lib/grey/monkey_patch.rb`) with `rackup -q` or env config; consider Zeitwerk for
  the manual require list in `lib/grey.rb`.

### Infrastructure and architecture

- Geo query (spots near lat/lng) — Postgres extension choice, spatial indexes, `EXPLAIN`.
- Rate limiting middleware — shared mutable state under puma threads; the
  quarantined-state rule in practice.
- HTTP caching: ETag / Last-Modified / conditional GET — what `fresh_when` does.
- Postgres-backed job queue (`SKIP LOCKED`, retries, idempotency) — what Sidekiq /
  SolidQueue do.
- Import pipeline (CSV/GeoJSON → spots) as an async job with a status endpoint —
  batching, transactions, partial-failure reporting.
- Zero-downtime migration: add column, batched backfill, constraint after —
  strong_migrations concepts.
- Deployment: container, a real target, health check, graceful shutdown. README still
  points at the Heroku free tier and `procfile` needs capitalising.
- Load test plus puma / AR pool tuning — closes the concurrency gap from the walkthrough.
- Structured metrics and tracing on top of the canonical log line (OTel) — wide
  events → spans.
- Serializer recursion (SpotType ↔ Spot) terminates by convention only — make it
  structural (or adopt Blueprinter) before a third nested model appears.

### Non-goals

CRUD-shaped features (photos, user accounts, per-client auth, check-ins). They teach
nothing new.
