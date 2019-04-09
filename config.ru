# frozen_string_literal: true

require 'bundler/setup'
Bundler.require

require_relative './lib/grey'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: %i[get post put delete]
  end
end

# flush log messages straight away
$stdout.sync = true
$stderr.sync = true

# keep on top of middleware stack
use Grey::Middleware::ApiLogLine, emitter: Grey::ApiLogLineEmitter.new(
  logger: Grey::Config.logger
)

use Grey::Middleware::Instrumentation
run Grey::ApiAggregator
