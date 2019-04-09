# frozen_string_literal: true

require 'bundler/setup'
Bundler.require

# Add lib to paths for ease.
$LOAD_PATH << './lib'

require 'grey'

ActiveRecord::Base.establish_connection(Grey::Config.database_url)

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
unless Grey::Config.test_env?
  use Grey::Middleware::ApiLogLine, emitter: Grey::ApiLogLineEmitter.new(
    logger: Grey::Config.logger
  )
end

use Grey::Middleware::Instrumentation
run Grey::ApiAggregator
