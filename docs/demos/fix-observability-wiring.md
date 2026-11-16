# Observability wiring: request ID lifecycle

*2026-11-16T11:09:58Z by Showboat 0.6.1*
<!-- showboat-id: 0cc4a770-7ce9-4d4d-abb6-cf3924931567 -->

Slice 1. Instrumentation now assigns REQUEST_ID before the app runs and echoes it to the client as X-Request-Id. Recorded against the real config.ru stack.

```bash
bin/demo-server start
```

```output
demo server listening on http://localhost:9393 (log: tmp/demo-server.log)
```

A 404 carries the header (UUID masked so verify can replay):

```bash
curl -si localhost:9393/v0/spots/999999 | grep -iE "^HTTP|^x-request-id" | sed -E "s/[0-9a-f]{8}-[0-9a-f-]{27}/<uuid>/"
```

```output
HTTP/1.1 404 Not Found
x-request-id: <uuid>
```

The header and the log line carry the same ID. Take the UUID from a 200 response and count log lines with that request_id:

```bash
id=$(curl -si localhost:9393/v0/spot_types | awk "tolower(\$1)==\"x-request-id:\" {print \$2}" | tr -d "\r"); grep -c "request_id=$id" tmp/demo-server.log
```

```output
1
```

Still broken, fixed in the next slice: an errored request produces no log line at all, because ApiLogLine references an undefined constant and its bare rescue swallows the NameError. The last line of the log after the 404 above is the fallback message, not a log line:

```bash
grep -c "ApiLogLine failed to emit log" tmp/demo-server.log
```

```output
1
```

```bash
bin/demo-server stop
```

```output
demo server stopped
```
