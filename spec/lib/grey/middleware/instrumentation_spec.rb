# frozen_string_literal: true

require_relative "../../../spec_helper"

describe Grey::Middleware::Instrumentation do
  let(:uuid) { /\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/ }

  # Downstream app that records the env it was called with, so the spec can
  # assert on what the app saw *during* the request, not just after the unwind.
  let(:downstream) do
    lambda do |env|
      @env_seen_by_app = env.dup
      [200, {"content-type" => "application/json"}, ["{}"]]
    end
  end

  let(:middleware) { described_class.new(downstream) }

  def call(env = Rack::MockRequest.env_for("/v0/spots"))
    status, headers, body = middleware.call(env)
    [status, Rack::Headers[headers], body]
  end

  it "assigns a request ID the downstream app can see" do
    call
    expect(@env_seen_by_app["REQUEST_ID"]).to match(uuid)
  end

  it "echoes the same request ID to the client as an X-Request-Id header" do
    _status, headers, _body = call
    expect(headers["x-request-id"]).to match(uuid)
    expect(headers["x-request-id"]).to eq(@env_seen_by_app["REQUEST_ID"])
  end

  it "leaves the request ID in env after the call for upstream middleware" do
    env = Rack::MockRequest.env_for("/v0/spots")
    call(env)
    expect(env["REQUEST_ID"]).to eq(@env_seen_by_app["REQUEST_ID"])
  end

  it "assigns a distinct ID per request" do
    _s, first, _b = call
    _s, second, _b = call
    expect(first["x-request-id"]).not_to eq(second["x-request-id"])
  end

  it "passes the downstream status and body through untouched" do
    status, _headers, body = call
    expect(status).to eq 200
    expect(body).to eq ["{}"]
  end
end
