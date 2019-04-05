# frozen_string_literal: true

require 'bundler/setup'
Bundler.require

require_relative './lib/grey'

Grey::Config.database_url
Grey::Config.logger

run Grey::ApiAggregator
