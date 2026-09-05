# frozen_string_literal: true

require_relative "lib/grey/boot"

use Rack::Cors do
  allow do
    origins "*"
    resource "*", headers: :any, methods: %i[get post put delete]
  end
end

# flush log messages straight away
$stdout.sync = true
$stderr.sync = true

# keep on top of middleware stack
unless Grey::Config.test_env?
  use Grey::Middleware::ApiLogLine, emitter: Grey::ApiLogLineEmitter.new(
    logger: Grey::Config.logger
  )
end

use Grey::Middleware::Instrumentation
run Grey::ApiAggregator
