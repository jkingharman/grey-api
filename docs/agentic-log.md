# Agentic engineering log

Grey is a vehicle for practising agentic engineering (see CLAUDE.md "Why this project
exists"). This file holds the technique ladder, the feature backlog, their pairings,
and the retrospective log. One rule: no feature ships without a technique not yet
logged below.

## Ladder (roughly cost-ordered) × feature pairings

| # | Technique | Paired feature | Why the pairing works |
|---|-----------|----------------|-----------------------|
| 0 | `/fewer-permission-prompts` → project `.claude/settings.json` allowlist | TODO §7 harness groundwork | Generated from real transcripts; prerequisite for every hands-off rung below |
| 1 | Prompting styles: TDD-first vs hands-off vs `/code-review --fix` | The four walkthrough bugs (ApiError typo in `api_log_line.rb`; error UUID never returned to client; `REQUEST_ID` set after `@app.call`; `text/error` content type) + `db:rollback` fix (TODO §4, §6) | Small, known-shape fixes — one per style, then compare; the TDD-first variant produces the missing `ApiLogLine`/`Instrumentation` specs (TODO §1) as a side effect |
| 2 | Plan mode with a written spec | Geo query (spots near lat/lng) — or boot consolidation (TODO §5) as a contrast exercise where the spec is "behaviour identical, structure different" | Real design decisions to plan: PostGIS vs earthdistance vs haversine-in-SQL, index choice, param validation; touches model, endpoint, serializer, spec |
| 3 | Custom skill encoding the Grape pattern (`/new-resource`: endpoint + serializer + spec + mount) | A genuinely new resource (e.g. `areas`/boroughs) | Forces the conventions to be articulated precisely enough for an agent to follow |
| 4 | Hooks beyond lint: PostToolUse running touched specs, PreToolUse guarding migrations | Auth rework (per-client API keys replacing single `API_KEY` basic auth) | Has a migration for the guard to bite on; hooks run outside the model's context — enforcement, not prompting |
| 5 | Read-only reviewer subagent with its own instructions | Review the auth branch before merge | Separation of author and reviewer contexts |
| 6 | Postgres MCP server against the dev DB | Data exploration ahead of the import pipeline | Lets the agent query real data instead of guessing at shapes |
| 7 | Headless `claude -p` in a script | Changelog generation, or an import validation report | Agent as a build step rather than a conversation |
| 8 | Parallel worktrees, two agents at once | Rate limiting (middleware) + pagination/filtering on index endpoints | Independent slices; per-worktree test DBs already support this |
| 9 | Multi-agent workflow / agent team | Import pipeline (CSV/GeoJSON → spots) end to end | Multi-step with natural fan-out: parse, validate, geocode, insert, report |

## Feature backlog (unpaired / future)

- Sessions or check-ins resource (users logging visits to spots)
- Photo attachments for spots
- Public read-only rate limits distinct from write auth
- Full-text search improvements (pg_search weighting, headline)

## Unpaired techniques

- Driving work from `gh` issues with acceptance criteria (supersedes the TODO §7
  "exercise backlog" item — one backlog lives here, issues are a technique to try later)
- Stop hook that nags when a task ends without a log entry below (mechanical check
  only — hooks run outside the model's context and can't judge what was practised)

## Log

<!-- Append after each task: date, technique, feature, what broke, verdict. -->
