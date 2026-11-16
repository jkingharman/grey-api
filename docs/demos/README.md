# Demos

One Showboat document per PR, named after the branch, proving the change was run
against the real stack. These are evidence at review time and history afterwards:
they are never updated after merge, so old ones will drift from the app.

Replay one with `bin/showboat verify docs/demos/<name>.md` after `bin/demo-server start`.
A failing verify on an old demo is expected drift, not a bug.
