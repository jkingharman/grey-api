# Verification harness: demo server, Showboat wrapper, push gate

*2026-11-16T08:49:46Z by Showboat 0.6.1*
<!-- showboat-id: ef490f11-fc06-4627-89a2-7822a8ce8cfa -->

This PR adds the harness itself, so the demo shows the harness working: the demo server boots the real stack, a request produces a canonical log line, and the push gate refuses a push of app code that has no demo.

```bash
bin/demo-server start
```

```output
demo server listening on http://localhost:9393 (log: tmp/demo-server.log)
```

```bash
curl -s -o /dev/null -w "%{http_code}\n" localhost:9393/v0/spot_types
```

```output
200
```

The log line for that request, with the UUID and timestamp masked so verify can replay it:

```bash
tail -1 tmp/demo-server.log | sed -E "s/[0-9a-f]{8}-[0-9a-f-]{27}/<uuid>/; s/datetime=\"[^\"]*\"/datetime=<ts>/; s/timing_total_elapsed=[0-9.]+/timing_total_elapsed=<n>/"
```

```output
level=INFO datetime=<ts> progname= request_id=<uuid> request_ip="::1" request_method=GET request_path="/v0/spot_types" request_user_agent="curl/8.7.1" response_status=200 timing_total_elapsed=<n>
```

The push gate, fed the payload Claude Code would send for a git push. This branch changes bin/ and, at the moment of recording, has no demo committed, so it is refused:

```bash
echo "{\"tool_input\":{\"command\":\"git push origin verification-harness\"}}" | bin/demo-hook | jq -r .hookSpecificOutput.permissionDecisionReason
```

```output
Branch changes app code but adds no demo under docs/demos/. Start bin/demo-server, record the check with bin/showboat, commit it, then push (CLAUDE.md, Verification).
```

A non-push command passes through silently:

```bash
echo "{\"tool_input\":{\"command\":\"git status\"}}" | bin/demo-hook; echo "exit $?"
```

```output
exit 0
```

```bash
bin/demo-server stop
```

```output
demo server stopped
```
