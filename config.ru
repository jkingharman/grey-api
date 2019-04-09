# frozen_string_literal: true

require 'bundler/setup'
Bundler.require

require_relative './lib/grey'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :put, :delete]
  end
end

Grey::Config.logger

use Grey::ApiLogLineEmitter
run Grey::ApiAggregator
