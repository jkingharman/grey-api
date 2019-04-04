# frozen_string_literal: true

require 'bundler/setup'
Bundler.require

require_relative './lib/grey'

logger = Grey::Config.logger(log_path: "./log/grey.log")

use Rack::CommonLogger, logger
run Grey::ApiAggregator
